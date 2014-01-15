FS = require 'fs'
Q = require 'q'

###
Class for generating JSON product type representations from CSV files.
###
class ProductTypeGenerator
    
  constructor: (options = {}) ->
    @_options = options

  ###
  Creates sphere product type representation files using JSON format.
  @param {array} types Entire types CSV as an array of records.
  @param {array} attributes Entire attributes CSV as an array of records.
  @param {function} callback The callback function to be invoked when the method finished its work.
  @return Result of the given callback
  ###
  run: (types, attributes, callback) ->
    callback true

module.exports = ProductTypeGenerator