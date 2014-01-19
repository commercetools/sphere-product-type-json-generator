sphere-product-type-json-generator
=================================

[![Dependency Status](https://david-dm.org/svenmueller/sphere-product-type-json-generator.png)](https://david-dm.org/svenmueller/sphere-product-type-json-generator) [![Build Status](https://travis-ci.org/svenmueller/sphere-product-type-json-generator.png?branch=master)](https://travis-ci.org/svenmueller/sphere-product-type-json-generator) [![Coverage Status](https://coveralls.io/repos/svenmueller/sphere-product-type-json-generator/badge.png)](https://coveralls.io/r/svenmueller/sphere-product-type-json-generator) [![NPM version](https://badge.fury.io/js/sphere-product-type-json-generator.png)](http://badge.fury.io/js/sphere-product-type-json-generator)

A command line for processing given _CSV_ files and generating a _JSON_ product type representation file for each product type. As input two _CSV_ files are required:
* a _CSV_ file describing available attribute values (e.g. for atttributes of type _Enumeration_)
* a _CSV_ file describing available product types

## How to develop

Install the required dependencies
```bash
npm install
```

All source files are written in `coffeescript`. [Grunt](http://gruntjs.com/) is used as build tool. The generated source files are located in `/lib`.
```bash
grunt build
```

## How to run

List available options and usage info.
```bash
node lib/run.js
Usage: node ./lib/run.js --types [CSV] --attributes [CSV] --target [folder] --retailer [boolean]

Options:
  --types, -t       Path to product types CSV file.                                                                            [required]
  --attributes, -a  Path to product type attributes CSV file.                                                                  [required]
  --target, -t      Target folder for generated product types JSON files.                                                      [required]
  --retailer, -r    Master/Retailer. Set "true" to generate another product type file, having an extra attribute "masterSKU".  [default: false]


Missing required arguments: types, attributes, target
```

Example
```
node lib/run.js --types data/sample-product-types.csv --attributes \
	data/sample-product-types-attributes.csv --target ./
```

### How to test

Specs are located under `/src/spec` and written as [Jasmine](http://pivotal.github.io/jasmine/) test.
```bash
grunt test
```

To run them on any file change
```bash
grunt watch:test
```

## Styleguide
We <3 CoffeeScript here at commercetools! So please have a look at this referenced [coffeescript styleguide](https://github.com/polarmobile/coffeescript-style-guide) when doing changes to the code.

