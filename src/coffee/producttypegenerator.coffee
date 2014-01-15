xmlbuilder = require 'xmlbuilder'
FS = require 'fs'
Q = require 'q'

###
Class for generating JSON product type representations from CSV files.
###
class ProductTypeGenerator
  
  _options = {}

  constructor: (options = {}) ->
    @_options = options

  ###
  Creates sphere product type representation files using JSON format.
  @return true if generation was successfull otherwise false
  ###
  run: (types, attributes, callback) ->
    console.log "ProductTypeGenerator.run()"
    console.log "#{types}"
    console.log "#{attributes}"
    callback true

module.exports = ProductTypeGenerator