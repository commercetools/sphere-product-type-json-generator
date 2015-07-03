![SPHERE.IO icon](https://admin.sphere.io/assets/images/sphere_logo_rgb_long.png)

# ProductType JSON generator

[![NPM](https://nodei.co/npm/sphere-product-type-json-generator.png?downloads=true)](https://www.npmjs.org/package/sphere-product-type-json-generator)

[![Build Status](https://travis-ci.org/sphereio/sphere-product-type-json-generator.png?branch=master)](https://travis-ci.org/sphereio/sphere-product-type-json-generator) [![Dependency Status](https://david-dm.org/sphereio/sphere-product-type-json-generator.png?theme=shields.io)](https://david-dm.org/sphereio/sphere-product-type-json-generator) [![devDependency Status](https://david-dm.org/sphereio/sphere-product-type-json-generator/dev-status.png?theme=shields.io)](https://david-dm.org/sphereio/sphere-product-type-json-generator#info=devDependencies) [![Coverage Status](https://coveralls.io/repos/sphereio/sphere-product-type-json-generator/badge.png?branch=master)](https://coveralls.io/r/sphereio/sphere-product-type-json-generator?branch=master) [![Code Climate](https://codeclimate.com/github/sphereio/sphere-product-type-json-generator.png)](https://codeclimate.com/github/sphereio/sphere-product-type-json-generator)

This component allows you to process given _CSV_ files in order to generate SPHERE.IO **ProductType** _JSON_ representations.

## Getting started

```bash
$ npm install -g sphere-product-type-json-generator
```
* build javascript sources
```bash
$ grunt build
```
# output help screen
$ product-type-generator
```

The component requires two _CSV_ files:
* a _CSV_ file describing available attribute values (e.g. for attributes of type _Enumeration_)
* a _CSV_ file describing available product types

> Please find some example CSV files in the [data](data) folder


### Posting generated product types
The generated JSON files can be used then to be directly imported via SPHERE.IO HTTP API to your project.
We provide a simple command to do that:

```bash
$ npm install -g sphere-product-type-json-generator

# output help screen
$ product-type-update
```

Simply pass the credentials and the `--source` of your file to be imported. If you provide a **directory**, all `*.json` files inside that directory will be posted.

## Docker

[![Docker build](http://dockeri.co/image/sphereio/product-type-json-generator)](https://registry.hub.docker.com/u/sphereio/product-type-json-generator/)

There is also a docker container for easy setup/execution.

Run docker container:
```bash
docker run -v /path/to/files/:/files sphereio/product-type-generator
```

Set an alias for repeated calls:
```bash
alias product-type='docker run -v /path/to/files/:/files sphereio/product-type-generator'
```

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).
More info [here](CONTRIBUTING.md)

## Releasing
Releasing a new version is completely automated using the Grunt task `grunt release`.

```javascript
grunt release // patch release
grunt release:minor // minor release
grunt release:major // major release
```

## License
Copyright (c) 2014 SPHERE.IO
Licensed under the [MIT license](LICENSE-MIT).
