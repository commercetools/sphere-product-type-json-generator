fs = require 'fs'
Q = require 'q'
CSV = require 'csv'
JSZip = require 'jszip'
{ProductTypeGenerator} = require '../main'

argv = require('optimist')
  .usage('Usage: $0 --types [CSV] --attributes [CSV] --target [folder] --retailer [boolean]')
  .alias('types', 't')
  .alias('attributes', 'a')
  .alias('target', 'td')
  .alias('retailer', 'r')
  .default('retailer', false)
  .default('zip', false)
  .default('zipFileName', 'generated-product-types')
  .describe('types', 'Path to product types CSV file.')
  .describe('attributes', 'Path to product type attributes CSV file.')
  .describe('target', 'Target directory for generated product types JSON files.')
  .describe('retailer', 'Master/Retailer. Set "true" to generate another product type file, having an extra attribute "mastersku".')
  .describe('zip', 'Whether to archive all generated files into a zipped file or not.')
  .describe('zipFileName', 'The zipped file name (without extension).')
  .demand(['types', 'attributes', 'target'])
  .argv


###
Reads a CSV file by given path and returns a promise for the result.
@param {string} path The path of the CSV file.
@return Promise of csv read result.
###
readCsvPromise = (path) ->
  deferred = Q.defer()
  CSV().from.path(path, {columns: true})
  .to.array (data, count) ->
    deferred.resolve(data)
  .on "error", (error) ->
    deferred.reject(new Error(error))
  deferred.promise

zipFiles = (path, filename) ->
  zip = new JSZip()
  zip.folder('product-type-json')
  generatedFiles = fs.readdirSync(path).filter (file) -> file.match(/\.json/)
  for file in generatedFiles
    zip.file("product-type-json/#{file}", fs.readFileSync("#{path}/#{file}", 'utf8'))
  buffer = zip.generate type: 'nodebuffer'
  fs.writeFileSync "#{path}/#{filename}.zip", buffer, 'utf8'

Q.spread [readCsvPromise(argv.types), readCsvPromise(argv.attributes)], (types, attributes) ->
  generator = new ProductTypeGenerator
  # make sure everything runs syncronous, otherwise zipped files will be empty (they will be not there)
  generator.run types, attributes, argv.target, argv.retailer
  zipFiles(argv.target, argv.zipFileName) if argv.zip
.fail (error) ->
  console.error "Oops, something went wrong: #{error.message}"
  process.exit 1
