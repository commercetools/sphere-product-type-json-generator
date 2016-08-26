_ = require 'underscore'
Promise = require 'bluebird'
ProductTypeImport = require 'sphere-product-type-import'
{ExtendedLogger, ProjectCredentialsConfig} = require 'sphere-node-utils'
package_json = require '../package.json'

class ProductTypeImporter

  ###
  Prepare for importing, initialize used modules
  ###
  init: (argv) ->
    @logOptions =
      name: "#{package_json.name}-#{package_json.version}"
      silent: !! argv.logSilent
      streams: [
        { level: 'error', stream: process.stderr }
        { level: argv.logLevel || 'info', path: "#{argv.logDir || '.'}/#{package_json.name}.log" }
      ]

    @logger = new ExtendedLogger
      additionalFields:
        'project_key': argv.projectKey
      logConfig: @logOptions
    if argv.logSilent
      @logger.bunyanLogger.trace = -> # noop
      @logger.bunyanLogger.debug = -> # noop

    @_ensureCredentials argv
    .then (credentials) ->
      @sphereImporter = new ProductTypeImport.default(@logger, credentials)
      Promise.resolve @

  ###
  Create sphere credentials config from command line arguments
  ###
  _ensureCredentials: (argv) ->
    credentialsPromise = null

    if argv.accessToken
      credentialsPromise = Promise.resolve
        config:
          project_key: argv.projectKey
        access_token: argv.accessToken
    else
      credentialsPromise = ProjectCredentialsConfig.create()
      .then (credentials) ->
        config: credentials.enrichCredentials
          project_key: argv.projectKey
          client_id: argv.clientId
          client_secret: argv.clientSecret

    credentialsPromise.then (credentials) ->
      options = _.extend credentials,
        timeout: argv.timeout
        user_agent: "#{package_json.name} - #{package_json.version}"

      options.host = argv.sphereHost if argv.sphereHost
      options.protocol = argv.sphereProtocol if argv.sphereProtocol
      if argv.sphereAuthHost
        options.oauth_host = argv.sphereAuthHost
        options.rejectUnauthorized = false
      options.oauth_protocol = argv.sphereAuthProtocol if argv.sphereAuthProtocol

      sphereClientConfig: options

  ###
  Import product types using sphere product import tool
  ###
  import: (data) ->
    console.log "Importing product types to sphere"
    Promise.map data.productTypes, (productType) ->
      @sphereImporter.importProductType productType
      .then (res) ->
        console.log "Imported product type", res.name
        Promise.resolve res
      .catch (e) ->
        console.error "Oops, something went wrong when importing product type #{productType.name} to sphere"
        Promise.reject e
    , concurrency: 5
module.exports = ProductTypeImporter
