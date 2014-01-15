CSV = require('csv')
Q = require('q')

argv = require('optimist')
  .usage('Usage: $0 --types product-types.csv --attributes product-types-attributes.csv')
  .demand(['types', 'attributes'])
  .argv

ProductTypeGenerator = require('../main').ProductTypeGenerator

###
Read CSV file by given path and promisifies the result.
@param {string} path The path to the csv file.
@return Promise of csv read result.
###
readCsvPromise = (path) ->
  deferred = Q.defer()
  CSV().from.path(path)
  .to (data) ->
    deferred.resolve(data)
  .on "error", (error) ->
    deferred.reject(new Error(error))
  deferred.promise

typesAndAttributesPromise = Q.all [readCsvPromise(argv.types), readCsvPromise(argv.attributes)]

Q.spread typesAndAttributesPromise, (types, attributes) ->
  generator = new ProductTypeGenerator
  generator.run types, attributes, (success) ->
    process.exit 1 unless success