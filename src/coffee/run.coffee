argv = require('optimist')
  .usage('Usage: $0 --product-types-csv productTypesCSV --product-types-attributes-csv productTypesAttributesCSV')
  .demand(['product-types-csv', 'product-types-attributes-csv'])
  .argv

ProductTypeGenerator = require('../main').ProductTypeGenerator

options =
  productTypesCSV: argv.productTypesCSV
  productTypesAttributesCSV: argv.productTypesAttributesCSV

generator = new ProductTypeGenerator options
generator.run (status) ->
  console.log status
  process.exit 1 unless msg.status