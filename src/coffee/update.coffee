_ = require 'underscore'
Promise = require 'bluebird'
fs = Promise.promisifyAll require('fs')
{SphereClient} = require 'sphere-node-sdk'
{ProjectCredentialsConfig} = require 'sphere-node-utils'
package_json = require '../package.json'
#test
argv = require('optimist')
  .usage('Usage: $0 --projectKey [key] --clientId [id] --clientSecret [secret] --source [path]')
  .describe('projectKey', 'your SPHERE.IO project-key')
  .describe('clientId', 'your OAuth client id for the SPHERE.IO API')
  .describe('clientSecret', 'your OAuth client secret for the SPHERE.IO API')
  .describe('source', 'path to JSON file or folder (in case of folder, all JSON files in that folder will be used)')
  .demand(['projectKey', 'source'])
  .argv

ProjectCredentialsConfig.create()
.then (config) ->
  credentials = config.enrichCredentials
    project_key: argv.projectKey
    client_id: argv.clientId
    client_secret: argv.clientSecret

  client = new SphereClient
    config: credentials
    user_agent: "#{package_json.name} - #{package_json.version}"

  processFile = (path) ->
    console.log "Processing file #{path}"
    fs.readFileAsync path, {encoding: 'utf-8'}
    .then (content) ->
      payload = JSON.parse content
      client.productTypes.create(payload)

  fs.exists argv.source, (exists) ->
    if exists
      fs.statAsync argv.source
      .then (stats) ->
        if stats.isFile()
          processFile argv.source
        else if stats.isDirectory()
          console.log "About to read all files in directory #{argv.source}"
          fs.readdirAsync argv.source
          .then (files) ->
            jsonFiles = _.filter files, (file) -> file.match(/\.json/)
            console.log "Processing #{_.size jsonFiles} files in directory #{argv.source}"
            Promise.map jsonFiles, (file) ->
              processFile "#{argv.source}/#{file}"
            , {concurrency: 1}
        else
          Promise.reject "Given path is not a file nor a directory #{argv.source}"
      .then ->
        console.log 'Product Types successfully posted to SPHERE.IO'
        process.exit 0
      .catch (e) ->
        console.error "Oops, something went wrong: #{e}"
        console.error("Body: %j", e.body) if e.body
        process.exit 1
    else
      console.error "Could not find #{argv.source} path"
      process.exit 1
