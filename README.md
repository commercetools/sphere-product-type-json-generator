sphere-producttype-json-generator
=================================

[![Build Status](https://travis-ci.org/svenmueller/sphere-producttype-json-generator.png?branch=master)](https://travis-ci.org/svenmueller/sphere-producttype-json-generator)

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

```
node lib/run.js --product-types product-types.csv --product-types-attributes product-types-attributes.csv
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

