_ = require 'underscore'
Csv = require 'csv'
path = require 'path'
Promise = require 'bluebird'
iconv = require 'iconv-lite'
fs = Promise.promisifyAll require('fs')
Excel = require 'exceljs'

debugLog = console.log
debugLog = _.noop


class Reader

  constructor: (@options = {}) ->
    debugLog "READER::options:", JSON.stringify(@options)
    @options.encoding = @options.encoding || 'utf-8'
    @options.csvDelimiter = @options.csvDelimiter || ','
    @header = null
    @rows = []

    if not iconv.encodingExists @options.encoding
      throw new Error 'Encoding does not exist: ' + @options.encoding

  read: (file) =>
    debugLog "READER::stream file %s", file
    @inputStream = fs.createReadStream file

    if @options.importFormat == 'xlsx'
      @_readXlsx(@inputStream)
    else
      @_readCsv(@inputStream)

  _mapRow: (header, row) ->
    res = {}
    header.forEach (item, index) ->
      res[item] = row[index]
    res

  _parseCsv: (csv, delimiter, encoding) =>
    header = null
    rows = []
    options =
      delimiter: delimiter
      skip_empty_lines: true

    # only buffer can be decoded from another encoding
    if csv instanceof Buffer
      csv = @_decode(csv, encoding)

    new Promise (resolve, reject) =>
      Csv()
      .from.string(csv, options)
      .on 'record', (row) =>
        if not header
          header = row
        else
          rows.push @_mapRow(header, row)
      .on 'error', (err) ->
        reject(err)
      .on 'end', ->
        resolve(rows)

  _readCsv: (stream) =>
    new Promise (resolve, reject) =>
      buffers = []

      # stream whole file to buffer because we need to decode it first from buffer
      # - iconv-lite does not support string to string decoding
      stream.on 'data', (buffer) ->
        buffers.push buffer
      stream.on 'error', (err) -> reject(err)
      stream.on 'end', =>
        buffer = Buffer.concat(buffers)
        @_parseCsv(buffer, @options.csvDelimiter, @options.encoding)
        .then (parsed) -> resolve(parsed)
        .catch (err) -> reject(err)

  _readXlsx: (stream) =>
    workbook = new Excel.Workbook()
    workbook.xlsx.read(stream)
    .then (workbook) =>
      header = null
      rows = []
      worksheet = workbook.getWorksheet(1)
      worksheet.eachRow (row) =>
        rowValues = row.values
        rowValues.shift()
        rowVaues = _.map rowValues, (item) ->
          if not item? or _.isObject(item)
            item = ""
          String(item)

        if not header
          header = rowVaues
        else
          rows.push @_mapRow(header, rowVaues)
      rows

  _decode: (buffer, encoding) ->
    debugLog "READER:decode from %s",encoding
    if encoding == 'utf-8'
      return buffer.toString()

    iconv.decode buffer, encoding

module.exports = Reader