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

  it 'should return JSON attribute definitions', ->

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
        inputHint: 'false'
        values:  [{ key: 'M', label: de: 'männlich', en: 'male' }, { key: 'W', label: de: 'weiblich', en: 'female' }, { key: 'U', label: de: 'unisex', en: 'unisex' }]

    expect(@generator._attributesDefinitions([attributeRow1, attributeRow2, attributeRow3])).toEqual expectedAttributeDefinition




