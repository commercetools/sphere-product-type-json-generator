CSV = require('csv')
Q = require('q')

argv = require('optimist')
  .usage('Usage: $0 --types product-types.csv --attributes product-types-attributes.csv --target generated')
  .demand(['types', 'attributes', 'target'])
  .argv

ProductTypeGenerator = require('../main').ProductTypeGenerator

options =
  target: argv.target

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
  generator = new ProductTypeGenerator options
  generator.run types, attributes, (success) ->
    process.exit 1 unless success
.fail (error) ->
  console.log "An error occured: #{error.message}"