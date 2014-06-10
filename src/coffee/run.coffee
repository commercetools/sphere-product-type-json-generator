Q = require 'q'
CSV = require 'csv'
{ProductTypeGenerator} = require '../main'

argv = require('optimist')
  .usage('Usage: $0 --types [CSV] --attributes [CSV] --target [folder] --retailer [boolean]')
  .alias('types', 't')
  .alias('attributes', 'a')
  .alias('target', 'td')
  .alias('retailer', 'r')
  .default('retailer', false)
  .describe('types', 'Path to product types CSV file.')
  .describe('attributes', 'Path to product type attributes CSV file.')
  .describe('target', 'Target directory for generated product types JSON files.')
  .describe('retailer', 'Master/Retailer. Set "true" to generate another product type file, having an extra attribute "mastersku".')
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

Q.spread [readCsvPromise(argv.types), readCsvPromise(argv.attributes)], (types, attributes) ->
  generator = new ProductTypeGenerator
  generator.run types, attributes, argv.target, argv.retailer, (success) -> process.exit 1 unless success
.fail (error) ->
  console.error "Oops, something went wrong: #{error.message}"
