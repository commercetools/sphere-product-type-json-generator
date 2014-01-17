FS = require 'fs'
Q = require 'q'
_ = require("underscore")._

###
Class for generating JSON product type representations from CSV files.
###
class ProductTypeGenerator

  ATTRIBUTE_TYPE_ENUM = 'enum'
  ATTRIBUTE_TYPE_LENUM = 'lenum'
  ATTRIBUTE_TYPE_ENUM_KEY = 'key'
  ATTRIBUTE_TYPE_TEXT = 'text'
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
  Returns an object containing all attribute definitions from given attribute CSV.
  @param {array} attributes Entire attributes CSV as an array of records.
  @return attribute definitions as object
  ###
  _attributesDefinitions: (attributes) ->

    # all attributes
    attributeDefinitions = {}
    lastProcessedAttributeDefinition = null


    for row, rowIndex in attributes

      # get language values from label header
      languages = @_languages ATTRIBUTE_LABEL, _.keys row

      # check if attribute name is empty
      if !!row[ATTRIBUTE_NAME]
        attributeDefinition =
          name: row[ATTRIBUTE_NAME]
          label: @_i18n row, ATTRIBUTE_LABEL, languages
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
          attributeDefinition['values'] = _.union (attributeDefinition['values'] or []),
            key: row[ATTRIBUTE_TYPE_ENUM_KEY]
            label: @_i18n row, "#{ATTRIBUTE_TYPE_ENUM}#{ATTRIBUTE_LABEL}", languages

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
    (languages(h) for h in headers when h.match(regexp))


  ###
  Returns an object containing a key/value pairs (language/value) for each language.
  @param {object} row The row object containing key/value pairs (header/value).
  @param {string}  header The attribute property header
  @param {array}  languages The languages used for i18n.
  @return Object with i18n values
  ###
  _i18n: (row, header, languages) ->
    i18n = {}
    for language in languages
      i18n[language] = row["#{header}.#{language}"]
    i18n

module.exports = ProductTypeGenerator