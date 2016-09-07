![SPHERE.IO icon](https://admin.sphere.io/assets/images/sphere_logo_rgb_long.png)

# ProductType JSON generator

[![NPM](https://nodei.co/npm/sphere-product-type-json-generator.png?downloads=true)](https://www.npmjs.org/package/sphere-product-type-json-generator)

[![Build Status](https://travis-ci.org/sphereio/sphere-product-type-json-generator.png?branch=master)](https://travis-ci.org/sphereio/sphere-product-type-json-generator) [![Dependency Status](https://david-dm.org/sphereio/sphere-product-type-json-generator.png?theme=shields.io)](https://david-dm.org/sphereio/sphere-product-type-json-generator) [![devDependency Status](https://david-dm.org/sphereio/sphere-product-type-json-generator/dev-status.png?theme=shields.io)](https://david-dm.org/sphereio/sphere-product-type-json-generator#info=devDependencies) [![Coverage Status](https://coveralls.io/repos/sphereio/sphere-product-type-json-generator/badge.png?branch=master)](https://coveralls.io/r/sphereio/sphere-product-type-json-generator?branch=master) [![Code Climate](https://codeclimate.com/github/sphereio/sphere-product-type-json-generator.png)](https://codeclimate.com/github/sphereio/sphere-product-type-json-generator)

This component allows you to generate SPHERE.IO **ProductType** _JSON_ drafts from _CSV_ files in order to create those product types in your SPHERE.IO project.

## Getting started

If you just want to use the tool, we recommend to use [SPHERE.IO's impex platform](https://impex.sphere.io) to avoid any local installation - you only need your browser.

Nevertheless you can run the program locally. You need [NodeJS](https://nodejs.org/download/) installed and simply run the following command in your terminal:

```bash
$ npm install -g sphere-product-type-json-generator
```

And then run:
```
$ product-type-generator
```

The component requires two _CSV_ files:
* a _CSV_ file describing product attributes and their values (e.g. for type _Enumeration_)
* a _CSV_ file describing product types in general and the used attributes

> Please find some example CSV files in the [data](data) folder

### Posting generated product types
The generated JSON files can be used then to be directly imported via SPHERE.IO HTTP API to your project.
We provide a simple command to do that:

```bash
$ product-type-update
```

Simply pass the credentials and your file to import via `--source`. If you provide a **directory**, all `*.json` files inside that directory will be uploaded.

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

## Development

* Clone this repository and change into the directory
* Install all necessary dependencies with

```bash
    npm install
```

* To run tests you have to set up credentials for sphere project first:
  For setting credentials you can create file in your home folder `~/.sphere-project-credentials.json` with content:
  
```
{
    "{PROJECT_ID}": {
        "client_id": "{CLIENT_ID}",
        "client_secret": "{CLIENT_SECRET}"
    }
}
```

 Than you can do:

```bash
  export SPHERE_PROJECT_KEY={PROJECT_ID}
  npm test
```

 This will start tests under sphere project `{PROJECT_ID}`.
  
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
