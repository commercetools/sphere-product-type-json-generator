Promise = require 'bluebird'
ProductTypeImporter = require '../lib/product-type-import'
{SphereClient} = require 'sphere-node-sdk'

errMissingCredentials = 'Missing configuration in env variables'

argv =
  clientId: process.env.SPHERE_CLIENT_ID
  clientSecret: process.env.SPHERE_CLIENT_SECRET
  projectKey: process.env.SPHERE_PROJECT_KEY
  logSilent: true

testProductType = {
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
  importer = null
  sphereClient = null

  beforeEach (done) ->
    expect(argv.clientId).toBeDefined errMissingCredentials
    expect(argv.clientSecret).toBeDefined errMissingCredentials
    expect(argv.projectKey).toBeDefined errMissingCredentials

    config =
      config:
        'client_id': argv.clientId
        'client_secret': argv.clientSecret
        'project_key': argv.projectKey
      stats:
        includeHeaders: true
        maskSensitiveHeaderData: true
    timeout: 360000

    sphereClient = new SphereClient config
    importer = new ProductTypeImporter
    importer.init(argv)
    .then ->
      sphereClient.productTypes.fetch()
      .then (res) ->
        console.log "Deleting old product types", res.body.results.length
        Promise.map res.body.results, (productType) ->
          sphereClient.productTypes.byId(productType.id)
          .delete(productType.version)
        .then ->
          done()
    .catch (e) ->
      done(e)

  it 'should import product type', (done) ->
    expect(importer).toBeDefined()
    expect(sphereClient).toBeDefined()

    sphereClient.productTypes.fetch()
    .then (res) ->
      expect(res.body.results.length).toEqual 0
      console.log "Importing product type using importer"
      importer.import {productTypes: [testProductType]}
    .then ->
      console.log "Product type imported - verifiing result"
      sphereClient.productTypes.fetch()
    .then (res) ->
      expect(res.body.results.length).toEqual 1

      done()
    .catch (e) ->
      done(e)

  it 'should not import wrong product type', (done) ->
    expect(importer).toBeDefined()
    expect(sphereClient).toBeDefined()

    delete testProductType.name
    importer.import {productTypes: [testProductType]}
    .then ->
      done "Importer wrong product type"
    .catch ->
      sphereClient.productTypes.fetch()
      .then (res) ->
        expect(res.body.results.length).toEqual 0
        done()
