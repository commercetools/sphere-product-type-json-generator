{expect} = require 'chai'
_ = require 'underscore'
Promise = require 'bluebird'
ProductTypeImporter = require '../../lib/product-type-import'
{SphereClient} = require 'sphere-node-sdk'
{ProjectCredentialsConfig} = require 'sphere-node-utils'
Helper = require '../helper/helper'

errMissingCredentials = 'Missing configuration in env variable named SPHERE_PROJECT_KEY'

argv =
  projectKey: process.env.SPHERE_PROJECT_KEY || "product-type-json-generator-int-test"
  logSilent: true

testProductType = {
  "key": "product-type-key",
  "name": "top_and_shirts",
  "description": "Tops & Shirts",
  "attributes": [
    {
      "name": "designer",
      "label": {
        "de": "Designer",
        "en": "designer"
      },
      "type": {
        "name": "text"
      },
      "attributeConstraint": "SameForAll",
      "isRequired": false,
      "isSearchable": false,
      "inputHint": "SingleLine"
    },
    {
      "name": "materialComposition",
      "label": {
        "de": "Zusammensetzung Material",
        "en": "material composition"
      },
      "type": {
        "name": "ltext"
      },
      "attributeConstraint": "None",
      "isRequired": false,
      "isSearchable": false,
      "inputHint": "MultiLine"
    }
  ]
}

describe 'ProductTypeImporter', ->
  this.timeout 30000
  importer = null
  sphereClient = null

  console.log "Using project %s for testing", argv.projectKey
  before ->
    expect(argv.projectKey).to.be.a 'string', errMissingCredentials

    ProjectCredentialsConfig.create()
    .then (credentials) ->
      sphereCredentials = credentials.enrichCredentials
        project_key: argv.projectKey

      config =
        projectKey: sphereCredentials.project_key,
        clientId: sphereCredentials.client_id,
        clientSecret: sphereCredentials.client_secret

      importer = new ProductTypeImporter
      importer.init config

      options =
        config: sphereCredentials
      sphereClient = new SphereClient options

  beforeEach ->
    # increase timeout so we will have time to delete all previous product types
    this.timeout 60000

    Helper.cleanProject sphereClient
    .then ->
      console.log "Product types were deleted"
    .catch (err) ->
      console.error "There was an error while deleting product types", err

  afterEach ->
    Helper.cleanProject sphereClient
    
  it('should import product type', ->
    sphereClient.productTypes.fetch()
    .then (res) ->
      expect(res.body.results.length).to.equal 0
      console.log "Importing product type using importer"
      importer.import {productTypes: [testProductType]}
    .then ->
      sphereClient.productTypes.fetch()
    .then (res) ->
      expect(res.body.results.length).to.equal 1
      expect(res.body.results[0].key).to.equal testProductType.key
  ).timeout(5000)

  it 'should not import wrong product type', (done) ->
    delete testProductType.name

    importer.import {productTypes: [testProductType]}
    .then ->
      done "Importer wrong product type"
    .catch (err) ->
      expect(err.toString()).to.equal '''Error: Validation error on productType "product-type-key" - should have required property \'name\''''
      sphereClient.productTypes.fetch()
      .then (res) ->
        expect(res.body.results.length).to.equal 0
        done()
    return 0 # do not return promise
