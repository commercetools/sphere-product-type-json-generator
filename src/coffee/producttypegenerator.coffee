FS = require 'fs'
Q = require 'q'

###
Class for generating JSON product type representations from CSV files.
###
class ProductTypeGenerator

  ATTRIBUTE_TYPE_ENUM = "enum"
  ATTRIBUTE_TYPE_TEXT = "text"
  ATTRIBUTE_TYPES = {ATTRIBUTE_TYPE_ENUM, ATTRIBUTE_TYPE_TEXT}

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

    attributesDefinitions = @_attributesDefinitions attributes

    callback true

  ###
  Creates as JSON object containing all attribute definitions from given attribute CSV.
  @param {array} attributes Entire attributes CSV as an array of records.
  @return attribute definitions as JSON object
  ###
  _attributesDefinitions: (attributes) ->

    # all attributes
    attributeDefinitions = {}
    lastProcessedAttributeDefinition = null


    for row, rowIndex in attributes

      # get language values from label header
      languages = @_languages ATTRIBUTE_LABEL, Object.keys(row)

      # check if attribute name is empty
      if !!row[ATTRIBUTE_NAME]
        attributeDefinition =
          name: row[ATTRIBUTE_NAME]
          label:
            'de': 'Designer'
            'en': 'Designer'
          type: row[ATTRIBUTE_TYPE]
          isVariant: row[ATTRIBUTE_IS_VARIANT]
          isRequired: row[ATTRIBUTE_IS_REQUIRED]
          inputHint: row[ATTRIBUTE_IS_REQUIRED]

        switch row[ATTRIBUTE_TYPE]
          when ATTRIBUTE_TYPE_ENUM
            attributeDefinition['values'] = {}

        # store attribute definition using name as key for easy access
        attributeDefinitions[row[ATTRIBUTE_NAME]] = attributeDefinition
        # store last processed attribute for further usage (reading next rows)
        lastProcessedAttributeDefinition = attributeDefinition

    attributeDefinitions

  ###
  Returns a list of languages (for i18n) used for given attribute property header.
  @param {string} name The name of the attribute property header.
  @param {array}  headers The headers used CSV.
  @return List with language values
  ###
  _languages: (name, headers) ->
    languages = []
    regexp = new RegExp("^#{name}\.[a-zA-Z]{2}", 'i')
    for header in headers
      if regexp.test header
        values = header.split('.')
        if values.length > 1
          # get language part from header
          languages.push values[1]
    languages


module.exports = ProductTypeGenerator