{SphereClient} = require 'sphere-node-sdk'
{ProjectCredentialsConfig} = require 'sphere-node-utils'
Helper = require '../helper/helper'

projectKey = process.env.SPHERE_PROJECT_KEY || "product-type-json-generator-tests"

describe 'Project cleanup', ->
  this.timeout 15000
  sphereClient = null

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

  it 'should cleanup project from productTypes', ->

    Helper.cleanProject sphereClient
      .then ->
        console.log "Project was cleaned"
      .catch (err) ->
        console.error "There was an error while deleting product types", err
