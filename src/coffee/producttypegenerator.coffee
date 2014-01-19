fs = require 'fs'
Q = require 'q'
_ = require("underscore")._

###
Class for generating JSON product type representations from CSV files.
###
class ProductTypeGenerator

  PRODUCT_TYPE_NAME = 'name'

  ATTRIBUTE_TYPE_ENUM = 'enum'
  ATTRIBUTE_TYPE_LENUM = 'lenum'
  ATTRIBUTE_TYPE_ENUM_KEY = 'key'
  ATTRIBUTE_TYPE_TEXT = 'text'
  ATTRIBUTE_TYPES = {ATTRIBUTE_TYPE_ENUM, ATTRIBUTE_TYPE_TEXT}
  ATTRIBUTE_ENUM_VALUES = 'values'

  ATTRIBUTE_NAME = 'name'
  ATTRIBUTE_LABEL = 'label'
  ATTRIBUTE_TYPE = 'type'
  ATTRIBUTE_IS_VARIANT = 'isVariant'
  ATTRIBUTE_IS_REQUIRED = 'isRequired'
  ATTRIBUTE_INPUT_HINT = 'inputHint'

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

    # build object with all attribute defintions for later usage
    attributeDefinitions = @_createAttributeDefinitions attributes

    # build product type definitions
    productTypeDefinitions = @_createProductTypesDefinitions types, attributeDefinitions

    # outpur product type files
    for productTypeDefinition in productTypeDefinitions
      @_writeFile productTypeDefinition

    callback true

  ###
  Returns an object containing all attribute definitions from given attribute CSV.
  @param {array} attributes Entire attributes CSV as an array of records.
  @return Object containing all attribute definitions
  ###
  _createAttributeDefinitions: (attributes) ->

    # all attributes
    attributeDefinitions = {}
    lastProcessedAttributeDefinition = null


    for row, rowIndex in attributes

      # check if attribute name is empty
      if !!row[ATTRIBUTE_NAME]
        attributeDefinition =
          name: row[ATTRIBUTE_NAME]
          label: @_i18n row, ATTRIBUTE_LABEL
          type: row[ATTRIBUTE_TYPE]
          isVariant: row[ATTRIBUTE_IS_VARIANT]
          isRequired: row[ATTRIBUTE_IS_REQUIRED]
          inputHint: row[ATTRIBUTE_IS_REQUIRED]

        # store attribute definition using name as key for easy access
        attributeDefinitions[row[ATTRIBUTE_NAME]] = attributeDefinition
        # store last processed attribute for further usage (reading next rows)
        lastProcessedAttributeDefinition = attributeDefinition
      else
        # process additional attribute rows
        attributeDefinition = lastProcessedAttributeDefinition

      switch attributeDefinition[ATTRIBUTE_TYPE]
        when ATTRIBUTE_TYPE_LENUM
          attributeDefinition[ATTRIBUTE_ENUM_VALUES] = _.union (attributeDefinition[ATTRIBUTE_ENUM_VALUES] or []),
            key: row[ATTRIBUTE_TYPE_ENUM_KEY]
            label: @_i18n row, "#{ATTRIBUTE_TYPE_ENUM}#{ATTRIBUTE_LABEL}"

    attributeDefinitions

  ###
  Returns a list of languages (for i18n) used for given attribute property header.
  @param {string} name The name of the attribute property header.
  @param {array}  headers The headers used CSV.
  @return List with language values
  ###
  _languages: (name, headers) ->
    regexp = new RegExp("^#{name}\.[a-zA-Z]{2}", 'i')
    languages = (header) ->
      # `match` will return null if there is no match, otherwise it returns an array with the matched group
      # In this case it will output this
      # 'label.de'.match(regexp) => ["label.de"]
      matched = header.match(regexp)
      # here we can safely access `matched` and split it since we know it matched what we wanted
      _.last(matched[0].split(".")) if matched

    # this will iterate over the array and execute the function if the condition is passed, returning a "filtered" array
    # see http://coffeescript.org/#loops
    (languages(header) for header in headers when header.match(regexp))


  ###
  Returns an object containing a key/value pairs (language/value) for each language.
  @param {object} row The row object containing key/value pairs (header/value).
  @param {string}  header The attribute property header
  @return Object with i18n values
  ###
  _i18n: (row, header) ->
    i18n = {}
    languages = @_languages header, _.keys row
    for language in languages
      i18n[language] = row["#{header}.#{language}"]
    i18n

  ###
  Returns an object containing a key/value pairs (language/value) for each language.
  @param {array} types Entire types CSV as an array of records.
  @param {object} attributeDefinitions The object containing all attribute definitions
  @return Array containing product type definition objects
  ###
  _createProductTypesDefinitions: (types, attributeDefinitions) ->

    productTypeDefinitions = []

    for row, rowIndex in types
      productTypeDefinition =
        name: row['name']
        description: row['description']

      productTypeDefinitions.push productTypeDefinition

    productTypeDefinitions

  ###
  Outputs given product definition as a file in JSON format.
  @param {object} productTypeDefinition The object containing product type definition.
  ###
  _writeFile: (productTypeDefinition, path) ->

    prettified = JSON.stringify productTypeDefinition, null, 4

    fileName = "#{@_options.target}/product-type-#{productTypeDefinition[PRODUCT_TYPE_NAME]}.json"
    fs.writeFile fileName, prettified, (error) ->
      if error
        console.log "Error while writing file #{fileName}: #{error}"

module.exports = ProductTypeGenerator