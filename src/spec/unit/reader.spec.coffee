path = require 'path'
fs = require 'fs'
iconv = require 'iconv-lite'
Excel = require 'exceljs'
_ = require 'lodash'
Promise = require 'bluebird'
tmp = require 'tmp'
{expect} = require 'chai'
Reader = require '../../lib/io/reader'

# will clean temporary files even when an uncaught exception occurs
tmp.setGracefulCleanup()

tempDir = null
unicodeString = "Příliš žluťoučký kůň úpěl ďábelské ódy"

dataInput = [
  ["num","num0","num1","num2","undefined","null","false","true","str"]
  [-1,0,1,2,undefined,null,false,true,unicodeString]
]
expectedOutput = {
  'num': '-1',
  'num0': '0',
  'num1': '1',
  'num2': '2',
  'undefined': '',
  'null': '',
  'false': 'false',
  'true': 'true',
  'str': unicodeString
}

writeXlsx = (filePath, data) ->
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

writeCsv = (filePath, data, delimiter) ->
  new Promise (resolve, reject) ->
    stream = fs.createWriteStream(filePath)
    stream.on 'error', reject
    stream.on 'finish', resolve

    data.forEach (row) ->
      if(_.isArray(row))
        row = row.join(delimiter) + '\n'
      stream.write row

    stream.end()

createReader = (fileType, delimiter = ',', encoding = 'utf-8' ) ->
  new Reader
    csvDelimiter: delimiter,
    encoding: encoding,
    importFormat: fileType,

describe 'Reader', ->
  before ->
    tempDir = tmp.dirSync({ unsafeCleanup: true })
    Promise.resolve()

  after ->
    tempDir.removeCallback()
    Promise.resolve()

  it 'should read xlsx file', ->
    tempFile = path.join(tempDir.name, 'data.xlsx')

    writeXlsx(tempFile, dataInput)
    .then ->
      createReader('xlsx').read(tempFile)
    .then (data) ->
      expect(data).to.be.an('array')
      expect(data.length).to.equal(1)
      expect(data[0]).to.deep.equal(expectedOutput)

  it 'should read csv file without provided options', ->
    tempFile = path.join(tempDir.name, 'data-simple.csv')

    writeCsv(tempFile, dataInput)
    .then ->
      (new Reader()).read(tempFile)
    .then (data) ->
      expect(data).to.be.an('array')
      expect(data.length).to.equal(1)
      expect(data[0]).to.deep.equal(expectedOutput)

  it 'should read csv file with custom delimiter', ->
    tempFile = path.join(tempDir.name, 'data.csv')

    writeCsv(tempFile, dataInput, ';')
    .then ->
      createReader('csv', ';').read(tempFile)
    .then (data) ->

      expect(data).to.be.an('array')
      expect(data.length).to.equal(1)
      expect(data[0]).to.deep.equal(expectedOutput)

  it 'should read csv file with custom encoding', ->
    tempFile = path.join(tempDir.name, 'data-encoding.csv')

    row = unicodeString + ',123'

    dataInput = [
      ['encodedString', 'numb']
      iconv.encode(row, 'win1250')
    ]

    writeCsv(tempFile, dataInput)
    .then ->
      createReader('csv', undefined, 'win1250').read(tempFile)
    .then (data) ->
      expect(data).to.be.an('array')
      expect(data.length).to.equal(1)
      expect(data[0].encodedString).to.equal(unicodeString)
      expect(data[0].numb).to.equal('123')


  it 'should not read csv file with unsupported encoding', ->
    tempFile = path.join(tempDir.name, 'data-wrong-encoding.csv')

    row = unicodeString + ',123'

    dataInput = [
      ['encodedString', 'numb']
      iconv.encode(row, 'win1250')
    ]

    writeCsv(tempFile, dataInput)
    .then ->
      try
        createReader('csv', undefined, 'unsupportedEncoding')
        Promise.reject('Should throw an error with unsupported encoding')
      catch e
        Promise.resolve()
