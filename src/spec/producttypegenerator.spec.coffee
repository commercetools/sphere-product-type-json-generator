ProductTypeGenerator = require('../main').ProductTypeGenerator

describe 'ProductTypeGenerator', ->
  beforeEach ->
    @generator = new ProductTypeGenerator('foo')

  it 'should initialize', ->
    expect(@generator).toBeDefined()

  it 'should initialize with options', ->
    expect(@generator._options).toBe 'foo'

  it 'should return languages for localized property header', ->
    expect(@generator._languages('label', ['name', 'label.de', 'label.en', 'enumlabel.de', 'enumlabel.en', 'enumlabel.it'])).toEqual ['de', 'en']

  it 'should return no languages for not localized property header', ->
    expect(@generator._languages('name', ['name', 'label.de', 'label.en', 'enumlabel.de', 'enumlabel.en', 'enumlabel.it'])).toEqual []

  it 'should return an object with localized values', ->

    attributeRow =
      name: 'gender'
      type: 'lenum'
      isVariant: 'false'
      isRequired: 'false'
      isSearchable: 'false'
      'label.de': 'Geschlecht'
      'label.en': 'gender'
      key: 'M'
      'enumlabel.en': 'male'
      'enumlabel.de': 'männlich'

    expect(@generator._i18n(attributeRow, 'label')).toEqual {de: 'Geschlecht', en: 'gender'}

  it 'should return an object with no localized values', ->
    expect(@generator._i18n(['name', 'label.de', 'label.en', 'enumlabel.de', 'enumlabel.en', 'enumlabel.it'], 'name')).toEqual []

  it 'should return one attribute definition of type text', ->

    attributeRow =
      name: 'description'
      type: 'text'
      isVariant: 'false'
      isRequired: 'false'
      isSearchable: 'false'
      inputHint: 'MultiLine'
      'label.de': 'Beschreibung'
      'label.en': 'Description'

    expectedAttributeDefinition =
      description:
        name: 'description'
        label:
          de: 'Beschreibung'
          en: 'Description'
        type: 'text'
        isVariant: 'false'
        isRequired: 'false'
        isSearchable: 'false'
        inputHint: 'MultiLine'

    expect(@generator._createAttributeDefinitions([attributeRow])).toEqual expectedAttributeDefinition

  it 'should return one attribute definition of type ltext', ->

    attributeRow =
      name: 'description'
      type: 'ltext'
      isVariant: 'false'
      isRequired: 'false'
      isSearchable: 'false'
      inputHint: 'MultiLine'
      'label.de': 'Beschreibung'
      'label.en': 'Description'

    expectedAttributeDefinition =
      description:
        name: 'description'
        label:
          de: 'Beschreibung'
          en: 'Description'
        type: 'ltext'
        isVariant: 'false'
        isRequired: 'false'
        isSearchable: 'false'
        inputHint: 'MultiLine'

    expect(@generator._createAttributeDefinitions([attributeRow])).toEqual expectedAttributeDefinition

  it 'should return one attribute definition of type enum', ->

    attributeRow1 =
      name: 'brand'
      type: 'enum'
      isVariant: 'false'
      isRequired: 'false'
      isSearchable: 'false'
      'label.de': 'Marke'
      'label.en': 'Brand'
      key: 'HUG'
      enumlabel: 'Hugo Boss'

    attributeRow2 =
      name: ''
      type: ''
      isVariant: ''
      isRequired: ''
      sSearchable: ''
      'label.de': ''
      'label.en': ''
      key: 'DUG'
      'enumlabel': 'Dolce&Gabana'

    expectedAttributeDefinition =
      brand:
        name: 'brand'
        label:
          de: 'Marke'
          en: 'Brand'
        type: 'enum'
        isVariant: 'false'
        isRequired: 'false'
        isSearchable: 'false'
        values:  [{ key: 'HUG', label: 'Hugo Boss' }, { key: 'DUG', label: 'Dolce&Gabana' }]

    expect(@generator._createAttributeDefinitions([attributeRow1, attributeRow2])).toEqual expectedAttributeDefinition

  it 'should return one attribute definition of type lenum', ->

    attributeRow1 =
      name: 'gender'
      type: 'lenum'
      isVariant: 'false'
      isRequired: 'false'
      isSearchable: 'false'
      'label.de': 'Geschlecht'
      'label.en': 'gender'
      key: 'M'
      'enumlabel.en': 'male'
      'enumlabel.de': 'männlich'

    attributeRow2 =
      name: ''
      type: ''
      isVariant: ''
      isRequired: ''
      sSearchable: ''
      'label.de': ''
      'label.en': ''
      key: 'W'
      'enumlabel.en': 'female'
      'enumlabel.de': 'weiblich'

    attributeRow3 =
      name: ''
      type: ''
      isVariant: ''
      isRequired: ''
      isSearchable: ''
      'label.de': ''
      'label.en': ''
      key: 'U'
      'enumlabel.en': 'unisex'
      'enumlabel.de': 'unisex'

    expectedAttributeDefinition =
      gender:
        name: 'gender'
        label:
          de: 'Geschlecht'
          en: 'gender'
        type: 'lenum'
        isVariant: 'false'
        isRequired: 'false'
        isSearchable: 'false'
        values:  [{ key: 'M', label: de: 'männlich', en: 'male' }, { key: 'W', label: de: 'weiblich', en: 'female' }, { key: 'U', label: de: 'unisex', en: 'unisex' }]

    expect(@generator._createAttributeDefinitions([attributeRow1, attributeRow2, attributeRow3])).toEqual expectedAttributeDefinition

  it 'should return an array with product type definitions', ->

    productTypeDefinition1 =
      name: 'ProductType1'
      description: 'Description1'

    productTypeDefinition2 =
      name: 'ProductType2'
      description: 'Description2'

    productTypeDefinitions = [productTypeDefinition1, productTypeDefinition2]

    attributeDefinitions = []

    expectedProductTypeDefinition1 =
      name: 'ProductType1'
      description: 'Description1'

    expectedProductTypeDefinition2 =
      name: 'ProductType2'
      description: 'Description2'

    expectedProductTypeDefinitions = [expectedProductTypeDefinition1, expectedProductTypeDefinition2]


    expect(@generator._createProductTypesDefinitions(productTypeDefinitions, attributeDefinitions)).toEqual expectedProductTypeDefinitions



