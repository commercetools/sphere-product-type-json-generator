path = require 'path'
iconv = require 'iconv-lite'
Promise = require 'bluebird'
tmp = require 'tmp'
{expect} = require 'chai'
Reader = require '../../lib/io/reader'
{writeXlsx, writeCsv, createReader} = require '../helper/helper'

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
      resultPromise = null

      try
        createReader 'csv', undefined, 'unsupportedEncoding'
        resultPromise = Promise.reject 'Should throw an error with unsupported encoding'
      catch e
        expect(e.message).to.equal 'Encoding does not exist: unsupportedEncoding'
        resultPromise = Promise.resolve()

      resultPromise