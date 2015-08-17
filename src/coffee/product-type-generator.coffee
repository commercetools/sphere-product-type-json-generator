_ = require 'underscore'
_.mixin require('underscore.string').exports()
Promise = require 'bluebird'
fs = Promise.promisifyAll require('fs')

# TODO: missing types
ATTRIBUTE_TYPES =
  text: 'text'
  ltext: 'ltext'
  enum: 'enum'
  lenum: 'lenum'
  set: 'set'
  reference: 'reference'
  nested: 'nested'

MASTER_SKU_NAME = 'mastersku'





###*
 * Class for generating JSON product-type representations from CSV files
 * @class ProductTypeGenerator
###
class ProductTypeGenerator


  ###*
   * Main exposed function that runs the program
   * @param  {Array} types The parsed CSV records of product-types
   * @param  {Array} attributes The parsed CSV records of product-type attributes
   * @param  {String} target The path to the folder where to write files
   * @param  {Boolean} withRetailer Wheter to generate extra files for master<->retailer support
   * @return {Promise} A promise resolved with summary report
  ###
  run: (types, attributes, target, withRetailer, client) ->
    @client = client
    new Promise (resolve, reject) =>

      try
        # build object with all attribute defintions for later usage
        attributeDefinitions = @_createAttributeDefinitions attributes

        # build product type definitions
        productTypeDefinitions = @_createProductTypesDefinitions types, attributeDefinitions

        # handle master/retailer product types
        if withRetailer
          # create attribute definition 'mastersku'
          attributeDefinitionMastersku = @_createAttributeDefinitionMastersku()
          # build product type definitions used in retailer projects
          productTypeDefinitionsRetailers = @_createProductTypesDefinitions types, attributeDefinitions, attributeDefinitionMastersku

        resolve
          productTypes: productTypeDefinitions
          productTypesForRetailer: productTypeDefinitionsRetailers
      catch e
        reject e

  ###*
   * Map all attribute definitions in the correct format
   * @param  {Array} attributes The parsed CSV records of product-type attributes
   * @return {Object} A JSON object that maps attribute definitions in correct format using name as key
  ###
  _createAttributeDefinitions: (attributes) ->
    attributeDefinitions = {}
    lastProcessedAttributeDefinition = null

    for row in attributes
      # check if attribute name is empty
      attrName = row['name']
      if !!attrName
        attributeDefinition =
          name: attrName
          label: @_i18n row, 'label'
          type:
            name: @_type row['type']
          attributeConstraint: row['attributeConstraint']
          isRequired: row['isRequired'] is 'true'
          isSearchable: row['isSearchable'] is 'true'

        # store attribute definition using name as key for easy access
        attributeDefinitions[attrName] = attributeDefinition
        # store last processed attribute for further usage (reading next rows)
        lastProcessedAttributeDefinition = attributeDefinition
      else
        # process additional attribute rows
        attributeDefinition = lastProcessedAttributeDefinition

      @_attributeDefinition row, attributeDefinition, attributeDefinition['type'], row['type']

    attributeDefinitions

  ###
  Builds an attribute definition instance (called recursivly for each part in given raw type name ('set:<type>').
  @param {object} row The row object containing key/value pairs (header/value).
  @param {object} attributeDefinition The object containing attribute definition
  @param {object} type The attribute type instance.
  @param {string} rawTypeName The raw attribute type name (e.g. 'set:text')
  ###
  _attributeDefinition: (row, attributeDefinition, type, rawTypeName) ->

    switch type.name
      when ATTRIBUTE_TYPES.text, ATTRIBUTE_TYPES.ltext
        attributeDefinition['inputHint'] = row['textInputHint']
      when ATTRIBUTE_TYPES.enum
        type['values'] = (type['values'] or []).concat [
          key: row['enumKey'].trim()
          label: row["#{ATTRIBUTE_TYPES.enum}Label"].trim()
        ]
      when ATTRIBUTE_TYPES.lenum
        type['values'] = (type['values'] or []).concat [
          key: row['enumKey'].trim()
          label: @_i18n row, "#{ATTRIBUTE_TYPES.enum}Label"
        ]
      when ATTRIBUTE_TYPES.reference
        if row['type']
          type['referenceTypeId'] = @_type(@_typeOrElementType(rawTypeName))
      when ATTRIBUTE_TYPES.set
        # TODO: ensure set is correctly build
        # e.g.: it will generate a wrong attribute definition for
        #   name,description,set_set_gender
        #   women,Woman Product Type,x
        attributeDefinition['isRequired'] = false
        attributeDefinition['isSearchable'] = false

        if row['type']
          type['elementType'] = {name: @_type(@_typeOrElementType(rawTypeName))}

        @_attributeDefinition row, attributeDefinition, type['elementType'], @_typeOrElementType rawTypeName
      when ATTRIBUTE_TYPES.nested
        # trying to find product type by name
        @_findProductTypeId(@_typeOrElementType(rawTypeName)).then(result) ->
          type['typeReference'] = {id: result ,typeId: "product-type" }


  ###*
   * Split the raw attribute type and return the attribute element type or the type itself
   * @param  {String} rawAttributeType The raw attribute type (e.g. 'text' or 'set:text')
   * @return {String} The mapped elements
   * @example
   *   'set:set:type' => 'set:type'
   *   'set:type'     => 'type'
   *   'text'         => 'text'
  ###
  _typeOrElementType: (rawAttributeType) ->
    parts = rawAttributeType.split(':')
    parts = parts[1..] unless parts.length == 1
    parts.join(':')

  ###*
   * Split the raw attribute type and return the first element, which is the real attribute type
   * @param  {String} rawAttributeType The raw attribute type (e.g. 'text' or 'set:text')
   * @return {String} The mapped elements types
   * @example
   *   'set:type' => 'set'
   *   'text'     => 'text'
  ###
  _type: (rawAttributeType) -> _.first rawAttributeType.split(':')

  ###*
   * Create an attribute definition 'masterSku' for master<->retailer support
  ###
  _createAttributeDefinitionMastersku: ->
    name: MASTER_SKU_NAME
    label:
      en: 'Master SKU'
    type:
      name: 'text'
    attributeConstraint: 'Unique'
    isRequired: true
    isSearchable: false
    inputHint: 'SingleLine'

  ###*
   * Map languages used for given attribute
   * @param  {String} name The name of the attribute header
   * @param  {Array} headers The list of headers from the CSV
   * @return {Array} The mapped list of languages
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

  ###*
   * Map key/value pairs for each language
   * @param  {Object} row The row containing key/value pairs (header/value)
   * @param  {String} header The attribute header
   * @return {Object} The mapped keys
  ###
  _i18n: (row, header) ->
    i18n = {}
    languages = @_languages header, _.keys row
    for language in languages
      i18n[language] = row["#{header}.#{language}"].trim()
    i18n

  ###*
   * Create product-type definition objects
   * @param  {Array} types The parsed CSV records of product-types
   * @param  {Object} attributeDefinitions The mapped attribute definitions
   * @param  {Object} [defaultAttributeDefinition] Some attribute definitions added to the resulting product type definitions
   * @return {Array} The list of generated product-type definitions
  ###
  _createProductTypesDefinitions: (types, attributeDefinitions, defaultAttributeDefinition) ->

    productTypeDefinitions = []

    for row in types
      productTypeDefinition =
        name: row['name']
        description: row['description']
        attributes: []

      for header, value of row
        continue if header is 'name' or header is 'description'

        if _.isString(value) and value.length > 0
          if attributeDefinitions[header]
            attributeDefinition = attributeDefinitions[header]
            attributeDefinition.name = value unless value.toLowerCase() is 'x'
            productTypeDefinition.attributes.push attributeDefinition
          else
            console.log "[WARN] No attribute definition found with name '#{header}', skipping..."

      # add default attribute definition to attributes
      if defaultAttributeDefinition
        productTypeDefinition.attributes.push defaultAttributeDefinition

      productTypeDefinitions.push productTypeDefinition
    productTypeDefinitions

  _findProductTypeId: (typeName) ->
    console.log "trying to find product type with name #{typeName}"
    new Promise (resolve, reject) =>
      @client.productTypes.where("name=#{typeName}").fetch().then(results) =>
        console.log "got result: #{results}"
        if results.body.count is 0
          reject "Didn't find any matching productType for name (#{typeName})"
        else
          if _.size(results.body.results) > 1
            console.log  "Found more than 1 #{typeName}, will use the first one I found"
          resolve(results.body.results[0].id)


module.exports = ProductTypeGenerator
