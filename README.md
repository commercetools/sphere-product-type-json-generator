![SPHERE.IO icon](https://admin.sphere.io/assets/images/sphere_logo_rgb_long.png)

# Node.js ProductType JSON generator

[![NPM](https://nodei.co/npm/sphere-product-type-json-generator.png?downloads=true)](https://www.npmjs.org/package/sphere-product-type-json-generator)

[![Build Status](https://travis-ci.org/sphereio/sphere-product-type-json-generator.png?branch=master)](https://travis-ci.org/sphereio/sphere-product-type-json-generator) [![Dependency Status](https://david-dm.org/sphereio/sphere-product-type-json-generator.png?theme=shields.io)](https://david-dm.org/sphereio/sphere-product-type-json-generator) [![devDependency Status](https://david-dm.org/sphereio/sphere-product-type-json-generator/dev-status.png?theme=shields.io)](https://david-dm.org/sphereio/sphere-product-type-json-generator#info=devDependencies) [![Coverage Status](https://coveralls.io/repos/sphereio/sphere-product-type-json-generator/badge.png?branch=master)](https://coveralls.io/r/sphereio/sphere-product-type-json-generator?branch=master) [![Code Climate](https://codeclimate.com/github/sphereio/sphere-product-type-json-generator.png)](https://codeclimate.com/github/sphereio/sphere-product-type-json-generator)

This component allows you to process given _CSV_ files in order to generate SPHERE.IO **ProductType** _JSON_ representations.

# Summary
The component requires two _CSV_ files:
* a _CSV_ file describing available attribute values (e.g. for attributes of type _Enumeration_)
* a _CSV_ file describing available product types

> Please find some example CSV files in the folder `data` folder.

The resulting JSON files can be used then to be directly imported via SPHERE.IO HTTP API to your project, e.g.: via cURL

```bash
curl -H "Authorization: Bearer {ACCESS_TOKEN}" -X POST -d @product-type-{NAME}.json https://api.sphere.io/{PROJECT_KEY}/product-types
```

> If you have several Product Types, you may want to use the little helper script to upload them all:

```bash
./upload-product-types.sh

upload-product-types.sh - Upload several product types

Arguments:
-p <project-key> - Your SPHERE.IO project key.
-t <token> - Your SPHERE.IO API access token.
-d <dir> - the directory, where the JSON files are located.
```

## Setup

```bash
npm install sphere-product-type-json-generator
```

## General Usage
List available options and usage info.

```bash
$ ./bin/product-type-generator
Usage: node ./bin/product-type-generator --types [CSV] --attributes [CSV] --target [folder] --retailer [boolean]

Options:
  --types, -t       Path to product types CSV file.                                                                            [required]
  --attributes, -a  Path to product type attributes CSV file.                                                                  [required]
  --target, --td    Target directory for generated product types JSON files.                                                   [required]
  --retailer, -r    Master/Retailer. Set "true" to generate another product type file, having an extra attribute "mastersku".  [default: false]
  --zip             Whether to archive all generated files into a zipped file or not.                                          [default: false]
  --zipFileName     The zipped file name (without extension).                                                                  [default: "generated-product-types"]

Missing required arguments: types, attributes, target
```

## Example

```bash
node ./bin/product-type-generator --types data/sample-product-types.csv --attributes \
	data/sample-product-types-attributes.csv --target ./
```

## How to develop

All source files are written in `coffeescript`. [Grunt](http://gruntjs.com/) is used as build tool. Generated source files are located in `/lib` folder. Before running the application compile your changes with:

```bash
grunt build
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
