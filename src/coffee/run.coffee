_ = require 'underscore'
Promise = require 'bluebird'
fs = Promise.promisifyAll require('fs')
Csv = require 'csv'
JSZip = require 'jszip'
ProductTypeGenerator = require './product-type-generator'

argv = require('optimist')
  .usage('Usage: $0 --types [CSV] --attributes [CSV] --target [folder] --retailer --zip --zipFileName [name]')
  .describe('types', 'path to CSV file describing product-type general info')
  .describe('attributes', 'path to CSV file describing product-type attributes info')
  .describe('target', 'target directory for generated product types JSON files')
  .describe('withRetailer', 'whether to generate an extra file for master<->retailer support with a "mastersku" attribute or not')
  .describe('zip', 'whether to zip the target folder or not')
  .describe('zipFileName', 'the zipped file name (without extension)')
  .default('retailer', false)
  .default('zip', false)
  .default('zipFileName', 'generated-product-types')
  .alias('types', 't')
  .alias('attributes', 'a')
  .alias('target', 'td')
  .alias('withRetailer', 'r')
  .boolean('withRetailer')
  .boolean('zip')
  .demand(['types', 'attributes', 'target'])
  .argv


###
Reads a CSV file by given path and returns a promise for the result.
@param {string} path The path of the CSV file.
@return Promise of csv read result.
###
readCsvAsync = (path) ->
  new Promise (resolve, reject) ->
    Csv().from.path(path, {columns: true})
    .to.array (data, count) -> resolve data
    .on 'error', (error) -> reject error

writeFileAsync = (productTypeDefinition, target, prefix = 'product-type') ->
  prettified = JSON.stringify productTypeDefinition, null, 2
  fileName = "#{target}/#{prefix}-#{productTypeDefinition['name']}.json"
  fs.writeFileAsync fileName, prettified, 'utf8'

zipFiles = (path, filename) ->
  zip = new JSZip()
  zip.folder('product-type-json')
  fs.readdirAsync(path)
  .then (allFiles) ->
    jsonFiles = _.filter allFiles, (file) -> file.match(/\.json/)
    Promise.map jsonFiles, (file) ->
      zip.file("product-type-json/#{file}", fs.readFileSync("#{path}/#{file}", 'utf8'))
    .then ->
      buffer = zip.generate type: 'nodebuffer'
      fs.writeFileAsync "#{path}/#{filename}.zip", buffer, 'utf8'

console.log 'About to read CSV files...'
Promise.all [readCsvAsync(argv.types), readCsvAsync(argv.attributes)]
.spread (types, attributes) ->
  console.log 'Running generator...'
  generator = new ProductTypeGenerator
  # TODO: make it async
  generator.run types, attributes, argv.target, argv.retailer
  .then (result) ->
    console.log 'About to write files...'
    if _.isEmpty result.productTypes
      Promise.reject new Error('We couldn\'t generate any file based on the given data. Please check your CSVs.')
    else
      Promise.map result.productTypes, (productType) ->
        writeFileAsync productType, argv.target
      .then ->
        console.log "Generated #{_.size result.productTypes} files for normal product-types"
        if argv.withRetailer
          if _.isEmpty result.productTypesForRetailer
            Promise.reject new Error('We couldn\'t generate any file for master<->retailer support based on the given data. Please check your CSVs.')
          else
            Promise.map result.productTypesForRetailer, (productType) ->
              writeFileAsync productType, argv.target, 'retailer-product-type'
            .then ->
              console.log "Generated #{_.size result.productTypesForRetailer} files for retailer product-types"
              Promise.resolve()
        else
          Promise.resolve()
      .then ->
        console.log "Finished generating files, checking results in target folder: #{argv.target}"
        fs.readdirAsync argv.target
        .then (files) ->
          if _.isEmpty files
            Promise.reject "No files were written in target folder #{argv.target}"
          else
            console.log "Found #{_.size files} files in target folder #{argv.target}"
            if argv.zip
              console.log "Zipping files as #{argv.zipFileName} name"
              zipFiles argv.target, argv.zipFileName
            else
              Promise.resolve()
        .catch (e) ->
          console.error "Oops, there was an error reading the files in target folder #{argv.target}: #{e.message}"
          process.exit 1
      .then ->
        console.log 'Execution successfully finished'
        process.exit 0
  .catch (e) ->
    console.error "Oops, something went wrong: #{e.message}"
    process.exit 1
.catch (e) ->
  console.error "Could not read CSV files: #{e.message}"
  process.exit 1
.done()

# Q.spread [readCsvPromise(argv.types), readCsvPromise(argv.attributes)], (types, attributes) ->
#   generator = new ProductTypeGenerator
#   # make sure everything runs syncronous, otherwise zipped files will be empty (they will be not there)
#   generator.run types, attributes, argv.target, argv.retailer
#   zipFiles(argv.target, argv.zipFileName) if argv.zip
# .fail (error) ->
#   console.error "Oops, something went wrong: #{error.message}"
#   process.exit 1
