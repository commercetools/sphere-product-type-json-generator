_ = require 'underscore'
fs = require 'fs'
Excel = require 'exceljs'
Promise = require 'bluebird'
Reader = require '../../lib/io/reader'

exports.writeXlsx = (filePath, data) ->
  workbook = new Excel.Workbook()
  workbook.created = new Date()
  worksheet = workbook.addWorksheet('Products')
  console.log "Generating Xlsx file"

  data.forEach (items, index) ->
    if index
      worksheet.addRow items
    else
      headers = []
      for i of items
        headers.push {
          header: items[i]
        }
      worksheet.columns = headers

  workbook.xlsx.writeFile(filePath)

exports.writeCsv = (filePath, data, delimiter) ->
  new Promise (resolve, reject) ->
    stream = fs.createWriteStream(filePath)
    stream.on 'error', reject
    stream.on 'finish', resolve

    data.forEach (row) ->
      if(_.isArray(row))
        row = row.join(delimiter) + '\n'
      stream.write row

    stream.end()

exports.createReader = (fileType, delimiter = ',', encoding = 'utf-8' ) ->
  new Reader
    csvDelimiter: delimiter,
    encoding: encoding,
    importFormat: fileType,
