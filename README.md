sphere-product-type-json-generator
=================================

[![Build Status](https://travis-ci.org/sphereio/sphere-product-type-json-generator.png?branch=master)](https://travis-ci.org/sphereio/sphere-product-type-json-generator) [![Coverage Status](https://coveralls.io/repos/sphereio/sphere-product-type-json-generator/badge.png)](https://coveralls.io/r/sphereio/sphere-product-type-json-generator) [![Dependency Status](https://david-dm.org/sphereio/sphere-product-type-json-generator.png?theme=shields.io)](https://david-dm.org/sphereio/sphere-product-type-json-generator) [![devDependency Status](https://david-dm.org/sphereio/sphere-product-type-json-generator/dev-status.png?theme=shields.io)](https://david-dm.org/sphereio/sphere-product-type-json-generator#info=devDependencies)

# Summary

This repository contains a command line tool for processing given _CSV_ files to generate SPHERE.IOs _JSON_ representations in a file for each product type.
As input two _CSV_ files are required:
* a _CSV_ file describing available attribute values (e.g. for atttributes of type _Enumeration_)
* a _CSV_ file describing available product types

Please find some example CSV files in the folder `data` folder.

White the resulting JSON files you can simply run the following curl command to create the product type in your SPHERE.IO project.
```bash
curl -H "Authorization: Bearer XyZ" -X POST -d @product-type-<name>.json https://api.sphere.io/<your-project-key>/product-types
```

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
  --target, -td     Target directory for generated product types JSON files.                                                   [required]
  --retailer, -r    Master/Retailer. Set "true" to generate another product type file, having an extra attribute "masterSKU".  [default: false]


Missing required arguments: types, attributes, target
```

Example
```bash
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

