xmlbuilder = require 'xmlbuilder'
fs = require 'fs'
Q = require 'q'

###
Class for generating JSON product type representations from CSV files.
###
class ProductTypeGenerator
  constructor: (options = {}) ->

  ###
  Creates sphere product type representation files using JSON format.
  @return true if generation was successfull otherwise false
  ###
  run: () ->
    console.log "ProductTypeGenerator.run()"
    true

module.exports = ProductTypeGenerator