/* ===========================================================
# sphere-product-type-json-generator - v0.1.3
# ==============================================================
# Copyright (c) 2014 Sven Müller
# Licensed under the MIT license.
*/
var CSV, JSZip, ProductTypeGenerator, Q, argv, fs, readCsvPromise, zipFiles;

fs = require('fs');

Q = require('q');

CSV = require('csv');

JSZip = require('jszip');

ProductTypeGenerator = require('../main').ProductTypeGenerator;

argv = require('optimist').usage('Usage: $0 --types [CSV] --attributes [CSV] --target [folder] --retailer --zip --zipFileName [name]').alias('types', 't').alias('attributes', 'a').alias('target', 'td').alias('retailer', 'r').boolean('retailer').boolean('zip')["default"]('zipFileName', 'generated-product-types').describe('types', 'Path to product types CSV file.').describe('attributes', 'Path to product type attributes CSV file.').describe('target', 'Target directory for generated product types JSON files.').describe('retailer', 'Master/Retailer. Set "true" to generate another product type file, having an extra attribute "mastersku".').describe('zip', 'Whether to archive all generated files into a zipped file or not.').describe('zipFileName', 'The zipped file name (without extension).').demand(['types', 'attributes', 'target']).argv;


/*
Reads a CSV file by given path and returns a promise for the result.
@param {string} path The path of the CSV file.
@return Promise of csv read result.
 */

readCsvPromise = function(path) {
  var deferred;
  deferred = Q.defer();
  CSV().from.path(path, {
    columns: true
  }).to.array(function(data, count) {
    return deferred.resolve(data);
  }).on("error", function(error) {
    return deferred.reject(new Error(error));
  });
  return deferred.promise;
};

zipFiles = function(path, filename) {
  var buffer, file, generatedFiles, zip, _i, _len;
  zip = new JSZip();
  zip.folder('product-type-json');
  generatedFiles = fs.readdirSync(path).filter(function(file) {
    return file.match(/\.json/);
  });
  for (_i = 0, _len = generatedFiles.length; _i < _len; _i++) {
    file = generatedFiles[_i];
    zip.file("product-type-json/" + file, fs.readFileSync("" + path + "/" + file, 'utf8'));
  }
  buffer = zip.generate({
    type: 'nodebuffer'
  });
  return fs.writeFileSync("" + path + "/" + filename + ".zip", buffer, 'utf8');
};

Q.spread([readCsvPromise(argv.types), readCsvPromise(argv.attributes)], function(types, attributes) {
  var generator;
  generator = new ProductTypeGenerator;
  generator.run(types, attributes, argv.target, argv.retailer);
  if (argv.zip) {
    return zipFiles(argv.target, argv.zipFileName);
  }
}).fail(function(error) {
  console.error("Oops, something went wrong: " + error.message);
  return process.exit(1);
});
