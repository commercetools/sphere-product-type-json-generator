ProductTypeGenerator = require '../lib/product-type-generator'

describe 'ProductTypeGenerator', ->

  beforeEach ->
    @generator = new ProductTypeGenerator
    expect(@generator).toBeDefined()

  it 'should return languages for localized property header', ->
    expect(@generator._languages('label', ['name', 'label.de', 'label.en', 'enumlabel.de', 'enumlabel.en', 'enumlabel.it'])).toEqual ['de', 'en']

  it 'should return no languages for not localized property header', ->
    expect(@generator._languages('name', ['name', 'label.de', 'label.en', 'enumlabel.de', 'enumlabel.en', 'enumlabel.it'])).toEqual []

  it 'should return an object with localized values', ->

    attributeRow =
      name: 'gender'
      type: 'lenum'
      attributeConstraint: 'None'
      isRequired: 'false'
      isSearchable: 'false'
      'label.de': 'Geschlecht'
      'label.en': 'gender'
      enumKey: 'M'
      'enumLabel.en': 'male'
      'enumLabel.de': 'männlich'

    expect(@generator._i18n(attributeRow, 'label')).toEqual {de: 'Geschlecht', en: 'gender'}

  it 'should return an object with no localized values', ->
    expect(@generator._i18n(['name', 'label.de', 'label.en', 'enumlabel.de', 'enumlabel.en', 'enumlabel.it'], 'name')).toEqual []

  it 'should return one attribute definition of type text', ->

    attributeRow =
      name: 'description'
      type: 'text'
      attributeConstraint: 'None'
      isRequired: 'false'
      isSearchable: 'false'
      textInputHint: 'MultiLine'
      'label.de': 'Beschreibung'
      'label.en': 'Description'

    expectedAttributeDefinition =
      description:
        name: 'description'
        label:
          de: 'Beschreibung'
          en: 'Description'
        type:
          name: 'text'
        attributeConstraint: 'None'
        isRequired: false
        isSearchable: false
        inputHint: 'MultiLine'

    expect(@generator._createAttributeDefinitions([attributeRow])).toEqual expectedAttributeDefinition

  it 'should return one attribute definition of type ltext', ->

    attributeRow =
      name: 'description'
      type: 'ltext'
      attributeConstraint: 'None'
      isRequired: 'false'
      isSearchable: 'false'
      textInputHint: 'MultiLine'
      'label.de': 'Beschreibung'
      'label.en': 'Description'

    expectedAttributeDefinition =
      description:
        name: 'description'
        label:
          de: 'Beschreibung'
          en: 'Description'
        type:
          name: 'ltext'
        attributeConstraint: 'None'
        isRequired: false
        isSearchable: false
        inputHint: 'MultiLine'

    expect(@generator._createAttributeDefinitions([attributeRow])).toEqual expectedAttributeDefinition

  it 'should return one attribute definition of type enum', ->

    attributeRow1 =
      name: 'brand'
      type: 'enum'
      attributeConstraint: 'None'
      isRequired: 'false'
      isSearchable: 'false'
      'label.de': 'Marke'
      'label.en': 'Brand'
      enumKey: 'HUG'
      enumLabel: 'Hugo Boss'

    attributeRow2 =
      name: ''
      type: ''
      attributeConstraint: ''
      isRequired: ''
      sSearchable: ''
      'label.de': ''
      'label.en': ''
      enumKey: 'DUG'
      'enumLabel': 'Dolce&Gabana'

    expectedAttributeDefinition =
      brand:
        name: 'brand'
        label:
          de: 'Marke'
          en: 'Brand'
        type:
          name: 'enum'
          values: [{ key: 'HUG', label: 'Hugo Boss' }, { key: 'DUG', label: 'Dolce&Gabana' }]
        attributeConstraint: 'None'
        isRequired: false
        isSearchable: false

    expect(@generator._createAttributeDefinitions([attributeRow1, attributeRow2])).toEqual expectedAttributeDefinition

  it 'should return one attribute definition of type lenum', ->

    attributeRow1 =
      name: 'gender'
      type: 'lenum'
      attributeConstraint: 'None'
      isRequired: 'false'
      isSearchable: 'false'
      'label.de': 'Geschlecht'
      'label.en': 'gender'
      enumKey: 'M'
      'enumLabel.en': 'male'
      'enumLabel.de': 'männlich'

    attributeRow2 =
      name: ''
      type: ''
      attributeConstraint: ''
      isRequired: ''
      sSearchable: ''
      'label.de': ''
      'label.en': ''
      enumKey: 'W'
      'enumLabel.en': 'female'
      'enumLabel.de': 'weiblich'

    attributeRow3 =
      name: ''
      type: ''
      attributeConstraint: ''
      isRequired: ''
      isSearchable: ''
      'label.de': ''
      'label.en': ''
      enumKey: 'U'
      'enumLabel.en': 'unisex'
      'enumLabel.de': 'unisex'

    expectedAttributeDefinition =
      gender:
        name: 'gender'
        label:
          de: 'Geschlecht'
          en: 'gender'
        type:
          name: 'lenum'
          values: [{ key: 'M', label: de: 'männlich', en: 'male' }, { key: 'W', label: de: 'weiblich', en: 'female' }, { key: 'U', label: de: 'unisex', en: 'unisex' }]
        attributeConstraint: 'None'
        isRequired: false
        isSearchable: false

    expect(@generator._createAttributeDefinitions([attributeRow1, attributeRow2, attributeRow3])).toEqual expectedAttributeDefinition

  it 'should return one attribute definition of type number', ->

    attributeRow =
      name: 'size'
      type: 'number'
      attributeConstraint: 'None'
      isRequired: 'false'
      isSearchable: 'false'
      'label.de': 'Größe'
      'label.en': 'Size'

    expectedAttributeDefinition =
      size:
        name: 'size'
        label:
          de: 'Größe'
          en: 'Size'
        type:
          name: 'number'
        attributeConstraint: 'None'
        isRequired: false
        isSearchable: false

    expect(@generator._createAttributeDefinitions([attributeRow])).toEqual expectedAttributeDefinition

  it 'should return one attribute definition of type money', ->

    attributeRow =
      name: 'listPrice'
      type: 'money'
      attributeConstraint: 'None'
      isRequired: 'false'
      isSearchable: 'false'
      'label.de': 'Listenpreis'
      'label.en': 'List price'

    expectedAttributeDefinition =
      listPrice:
        name: 'listPrice'
        label:
          de: 'Listenpreis'
          en: 'List price'
        type:
          name: 'money'
        attributeConstraint: 'None'
        isRequired: false
        isSearchable: false

    expect(@generator._createAttributeDefinitions([attributeRow])).toEqual expectedAttributeDefinition


  it 'should return one attribute definition of type date', ->

    attributeRow =
      name: 'releaseDate'
      type: 'date'
      attributeConstraint: 'None'
      isRequired: 'false'
      isSearchable: 'false'
      'label.de': 'Veröffentlichungsdatum'
      'label.en': 'Release date'

    expectedAttributeDefinition =
      releaseDate:
        name: 'releaseDate'
        label:
          de: 'Veröffentlichungsdatum'
          en: 'Release date'
        type:
          name: 'date'
        attributeConstraint: 'None'
        isRequired: false
        isSearchable: false

    expect(@generator._createAttributeDefinitions([attributeRow])).toEqual expectedAttributeDefinition

  it 'should return one attribute definition of type time', ->

    attributeRow =
      name: 'releaseTime'
      type: 'time'
      attributeConstraint: 'None'
      isRequired: 'false'
      isSearchable: 'false'
      'label.de': 'Veröffentlichungszeit'
      'label.en': 'Release time'

    expectedAttributeDefinition =
      releaseTime:
        name: 'releaseTime'
        label:
          de: 'Veröffentlichungszeit'
          en: 'Release time'
        type:
          name: 'time'
        attributeConstraint: 'None'
        isRequired: false
        isSearchable: false

    expect(@generator._createAttributeDefinitions([attributeRow])).toEqual expectedAttributeDefinition

  it 'should return one attribute definition of type dateTime', ->

    attributeRow =
      name: 'creationDateTime'
      type: 'dateTime'
      attributeConstraint: 'None'
      isRequired: 'false'
      isSearchable: 'false'
      'label.de': 'Herstellungszeit'
      'label.en': 'Creation time'

    expectedAttributeDefinition =
      creationDateTime:
        name: 'creationDateTime'
        label:
          de: 'Herstellungszeit'
          en: 'Creation time'
        type:
          name: 'dateTime'
        attributeConstraint: 'None'
        isRequired: false
        isSearchable: false

    expect(@generator._createAttributeDefinitions([attributeRow])).toEqual expectedAttributeDefinition

  it 'should return one attribute definition of type set (elementtype text)', ->

    attributeRow =
      name: 'infoLines'
      type: 'set:text'
      attributeConstraint: 'None'
      isRequired: ''
      isSearchable: ''
      'label.de': 'Info Zeilen'
      'label.en': 'Info Lines'
      textInputHint: 'MultiLine'

    expectedAttributeDefinition =
      infoLines:
        name: 'infoLines'
        label:
          de: 'Info Zeilen'
          en: 'Info Lines'
        type:
          name: 'set'
          elementType:
            name: 'text'
        attributeConstraint: 'None'
        inputHint: 'MultiLine'

    expect(@generator._createAttributeDefinitions([attributeRow])).toEqual expectedAttributeDefinition

  it 'should return one attribute definition of type set (elementtype enum)', ->

    attributeRow1 =
      name: 'brand'
      type: 'set:enum'
      attributeConstraint: 'None'
      isRequired: ''
      isSearchable: ''
      'label.de': 'Marke'
      'label.en': 'Brand'
      enumKey: 'HUG'
      enumLabel: 'Hugo Boss'

    attributeRow2 =
      name: ''
      type: ''
      attributeConstraint: ''
      isRequired: ''
      sSearchable: ''
      'label.de': ''
      'label.en': ''
      enumKey: 'DUG'
      'enumLabel': 'Dolce&Gabana'

    expectedAttributeDefinition =
      brand:
        name: 'brand'
        label:
          de: 'Marke'
          en: 'Brand'
        type:
          name: 'set'
          elementType:
            name: 'enum'
            values: [{ key: 'HUG', label: 'Hugo Boss' }, { key: 'DUG', label: 'Dolce&Gabana' }]
        attributeConstraint: 'None'

    expect(@generator._createAttributeDefinitions([attributeRow1, attributeRow2])).toEqual expectedAttributeDefinition

  it 'should return one attribute definition of type set (elementtype set with elementtype enum)', ->

    attributeRow1 =
      name: 'brand'
      type: 'set:set:enum'
      attributeConstraint: 'None'
      isRequired: ''
      isSearchable: ''
      'label.de': 'Marke'
      'label.en': 'Brand'
      enumKey: 'HUG'
      enumLabel: 'Hugo Boss'

    attributeRow2 =
      name: ''
      type: ''
      attributeConstraint: ''
      isRequired: ''
      sSearchable: ''
      'label.de': ''
      'label.en': ''
      enumKey: 'DUG'
      'enumLabel': 'Dolce&Gabana'

    expectedAttributeDefinition =
      brand:
        name: 'brand'
        label:
          de: 'Marke'
          en: 'Brand'
        type:
          name: 'set'
          elementType:
            name: 'set'
            elementType:
              name: 'enum'
              values: [{ key: 'HUG', label: 'Hugo Boss' }, { key: 'DUG', label: 'Dolce&Gabana' }]
        attributeConstraint: 'None'

    expect(@generator._createAttributeDefinitions([attributeRow1, attributeRow2])).toEqual expectedAttributeDefinition

  it 'should return an array with product type definitions with mastersku', ->

    productTypeDefinition1 =
      name: 'ProductType1'
      description: 'Description1'

    productTypeDefinition2 =
      name: 'ProductType2'
      description: 'Description2'

    productTypeDefinitions = [productTypeDefinition1, productTypeDefinition2]

    mastersku =
      name: 'mastersku'
      label:
        en: 'Master SKU'
      type:
        name: 'text'
      attributeConstraint: 'None'
      isRequired: true
      isSearchable: false
      inputHint: 'SingleLine'

    attributeDefinitions = []

    expectedProductTypeDefinition1 =
      name: 'ProductType1'
      description: 'Description1'
      attributes: [mastersku]

    expectedProductTypeDefinition2 =
      name: 'ProductType2'
      description: 'Description2'
      attributes: [mastersku]

    expectedProductTypeDefinitions = [expectedProductTypeDefinition1, expectedProductTypeDefinition2]

    expect(@generator._createProductTypesDefinitions(productTypeDefinitions, attributeDefinitions, mastersku)).toEqual expectedProductTypeDefinitions

  it 'should return an array with product type definitions with attributes', ->

    productTypeDefinition1 =
      name: 'ProductType1'
      description: 'Description1'
      information: 'x'

    productTypeDefinition2 =
      name: 'ProductType2'
      description: 'Description2'
      size: 'X'

    productTypeDefinitions = [productTypeDefinition1, productTypeDefinition2]

    mastersku =
      name: 'mastersku'
      label:
        en: 'Master SKU'
      type:
        name: 'text'
      attributeConstraint: 'None'
      isRequired: true
      isSearchable: false
      inputHint: 'SingleLine'

    size =
      name: 'size'
      label:
        de: 'Größe'
        en: 'Size'
      type:
        name: 'number'
      attributeConstraint: 'None'
      isRequired: false
      isSearchable: false
      inputHint: 'SingleLine'

    information =
      name: 'information'
      label:
        de: 'Information'
        en: 'Information'
      type:
        name: 'text'
      attributeConstraint: 'None'
      isRequired: false
      isSearchable: false
      inputHint: 'SingleLine'

    attributeDefinitions =
      size: size
      information: information

    expectedProductTypeDefinition1 =
      name: 'ProductType1'
      description: 'Description1'
      attributes: [information, mastersku]

    expectedProductTypeDefinition2 =
      name: 'ProductType2'
      description: 'Description2'
      attributes: [size, mastersku]

    expectedProductTypeDefinitions = [expectedProductTypeDefinition1, expectedProductTypeDefinition2]

    expect(@generator._createProductTypesDefinitions(productTypeDefinitions, attributeDefinitions, mastersku)).toEqual expectedProductTypeDefinitions

  it 'should skip product types with unkown product attributes', ->

    productTypeDefinition1 =
      name: 'ProductType1'
      description: 'Description1'
      unkownAttribute: 'x'

    productTypeDefinition2 =
      name: 'ProductType2'
      description: 'Description2'
      size: 'x'

    productTypeDefinitions = [productTypeDefinition1, productTypeDefinition2]

    size =
      name: 'size'
      label:
        de: 'Größe'
        en: 'Size'
      type:
        name: 'number'
      attributeConstraint: 'None'
      isRequired: false
      isSearchable: false
      inputHint: 'SingleLine'

    attributeDefinitions =
      size: size

    expectedProductTypeDefinitions = [
      {
        name: 'ProductType1'
        description: 'Description1'
        attributes: []
      },
      {
        name: 'ProductType2'
        description: 'Description2'
        attributes: [size]
      }
    ]

    expect(@generator._createProductTypesDefinitions(productTypeDefinitions, attributeDefinitions)).toEqual expectedProductTypeDefinitions

  it 'should return attribute with product type specific name', ->

    productTypeDefinition =
      name: 'myProductType'
      description: 'myDescription'
      size: 'myAttribName'

    size =
      name: 'size'
      label:
        de: 'Größe'
        en: 'Size'
      type:
        name: 'number'
      attributeConstraint: 'None'
      isRequired: false
      isSearchable: false
      inputHint: 'SingleLine'

    attributeDefinitions =
      size: size

    expectedProductTypeDefinition =
      name: 'myProductType'
      description: 'myDescription'
      attributes: [
        name: 'myAttribName'
        label:
          de: 'Größe'
          en: 'Size'
        type:
          name: 'number'
        attributeConstraint: 'None'
        isRequired: false
        isSearchable: false
        inputHint: 'SingleLine'
      ]

    expect(@generator._createProductTypesDefinitions([productTypeDefinition], attributeDefinitions)).toEqual [expectedProductTypeDefinition]

  it 'should return attribute definition for attribute mastersku', ->

    expectedAttributeDefinition =
      name: 'mastersku'
      label:
        en: 'Master SKU'
      type:
        name: 'text'
      attributeConstraint: 'Unique'
      isRequired: true
      isSearchable: false
      inputHint: 'SingleLine'

    expect(@generator._createAttributeDefinitionMastersku()).toEqual expectedAttributeDefinition

  it 'should return an attribute definition of type reference', ->

    attributeRow =
      name: 'zone_reference'
      type: 'reference:zone'
      attributeConstraint: 'None'
      isRequired: 'false'
      isSearchable: 'false'
      'label.de': 'Zone (de)'
      'label.en': 'Zone (en)'

    expectedAttributeDefinition =
      zone_reference:
        name: 'zone_reference'
        label:
          de: 'Zone (de)'
          en: 'Zone (en)'
        type:
          name: 'reference'
          referenceTypeId: 'zone'
        attributeConstraint: 'None'
        isRequired: false
        isSearchable: false

    expect(@generator._createAttributeDefinitions([attributeRow])).toEqual expectedAttributeDefinition

  it 'should split and return attribute element type or ettribute type', ->

    expect(@generator._typeOrElementType('set:set:type')).toBe 'set:type'
    expect(@generator._typeOrElementType('set:type')).toBe 'type'
    expect(@generator._typeOrElementType('type')).toBe 'type'

  it 'should split and return attribute type', ->

    expect(@generator._type('set:set:type')).toBe 'set'
    expect(@generator._type('set:type')).toBe 'set'
    expect(@generator._type('type')).toBe 'type'
