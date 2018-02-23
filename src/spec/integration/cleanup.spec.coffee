ProductTypeImporter = require '../../lib/product-type-import'
{SphereClient} = require 'sphere-node-sdk'
{ProjectCredentialsConfig} = require 'sphere-node-utils'
Helper = require '../helper/helper'

projectKey = process.env.SPHERE_PROJECT_KEY || "producttype-json-generator-tests"

describe 'Project cleanup', ->
  console.log "Removing productTypes from project", projectKey
  before ->
    ProjectCredentialsConfig.create()
    .then (credentials) ->
      sphereCredentials = credentials.enrichCredentials
        project_key: projectKey

      config =
        projectKey: sphereCredentials.project_key,
        clientId: sphereCredentials.client_id,
        clientSecret: sphereCredentials.client_secret

      options =
        config: sphereCredentials
      sphereClient = new SphereClient options

      Helper.cleanProject sphereClient