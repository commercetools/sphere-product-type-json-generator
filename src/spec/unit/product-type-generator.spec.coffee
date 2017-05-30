ProductTypeGenerator = require '../../lib/product-type-generator'
{expect} = require 'chai'

describe 'ProductTypeGenerator', ->

  beforeEach ->
    @generator = new ProductTypeGenerator
    expect(@generator).to.be.an 'object'

  it 'should return languages for localized property header', ->
    expect(@generator._languages('label', ['name', 'label.de', 'label.en', 'enumlabel.de', 'enumlabel.en', 'enumlabel.it'])).to.deep.equal ['de', 'en']

  it 'should return no languages for not localized property header', ->
    expect(@generator._languages('name', ['name', 'label.de', 'label.en', 'enumlabel.de', 'enumlabel.en', 'enumlabel.it'])).to.deep.equal []

  it 'should return full locale codes for localized property header', ->
    expect(@generator._languages('label', ['name', 'label.de-DE', 'label.en-US', 'enumlabel.de-DE', 'enumlabel.en-US', 'enumlabel.it-IT'])).to.deep.equal ['de-DE', 'en-US']


  it 'should return full locale codes and languages for localized property header', ->
    expect(@generator._languages('label', ['name', 'label.de', 'label.en-US', 'enumlabel.de', 'enumlabel.en-US', 'enumlabel.it-IT'])).to.deep.equal ['de', 'en-US']



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

    expect(@generator._i18n(attributeRow, 'label')).to.deep.equal {de: 'Geschlecht', en: 'gender'}

  it 'should return an object with localized inputTip values', ->

    attributeRow =
      name: 'gender'
      type: 'lenum'
      attributeConstraint: 'None'
      isRequired: 'false'
      isSearchable: 'false'
      'label.de': 'Geschlecht'
      'label.en': 'gender'
      'inputTip.de': 'tip de'
      'inputTip.en': 'tip en'
      enumKey: 'M'
      'enumLabel.en': 'male'
      'enumLabel.de': 'männlich'

    expect(@generator._i18n(attributeRow, 'inputTip')).to.deep.equal {de: 'tip de', en: 'tip en'}


  it 'should return an object with localized values using full locales and languages', ->

    attributeRow =
      name: 'gender'
      type: 'lenum'
      attributeConstraint: 'None'
      isRequired: 'false'
      isSearchable: 'false'
      'label.de-DE': 'Geschlecht'
      'label.en': 'gender'
      enumKey: 'M'
      'enumLabel.en': 'male'
      'enumLabel.de-DE': 'männlich'

    expect(@generator._i18n(attributeRow, 'label')).to.deep.equal {"de-DE": 'Geschlecht', en: 'gender'}

  it 'should return an object with no localized values', ->
    expect(@generator._i18n(['name', 'label.de', 'label.en', 'enumlabel.de', 'enumlabel.en', 'enumlabel.it'], 'name')).to.deep.equal {}

  it 'should return one attribute definition of type text', ->

    attributeRow =
      name: 'description'
      type: 'text'
      attributeConstraint: 'None'
      isRequired: 'false'
      isSearchable: 'false'
      textInputHint: 'MultiLine'
      'label.de-DE': 'Beschreibung'
      'label.en': 'Description'

    expectedAttributeDefinition =
      description:
        name: 'description'
        label:
          'de-DE': 'Beschreibung'
          en: 'Description'
        type:
          name: 'text'
        attributeConstraint: 'None'
        isRequired: false
        isSearchable: false
        inputHint: 'MultiLine'

    expect(@generator._createAttributeDefinitions([attributeRow])).to.deep.equal expectedAttributeDefinition

  it 'should return one attribute definition of type ltext', ->

    attributeRow =
      name: 'description'
      type: 'ltext'
      attributeConstraint: 'None'
      isRequired: 'false'
      isSearchable: 'false'
      textInputHint: 'MultiLine'
      'label.de-DE': 'Beschreibung'
      'label.en': 'Description'

    expectedAttributeDefinition =
      description:
        name: 'description'
        label:
          'de-DE': 'Beschreibung'
          en: 'Description'
        type:
          name: 'ltext'
        attributeConstraint: 'None'
        isRequired: false
        isSearchable: false
        inputHint: 'MultiLine'

    expect(@generator._createAttributeDefinitions([attributeRow])).to.deep.equal expectedAttributeDefinition

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

    expect(@generator._createAttributeDefinitions([attributeRow1, attributeRow2])).to.deep.equal expectedAttributeDefinition

  it 'should return one attribute definition of type lenum', ->

    attributeRow1 =
      name: 'gender'
      type: 'lenum'
      attributeConstraint: 'None'
      isRequired: 'false'
      isSearchable: 'false'
      'label.de': 'Geschlecht'
      'label.en-US': 'gender'
      enumKey: 'M'
      'enumLabel.en-US': 'male'
      'enumLabel.de': 'männlich'

    attributeRow2 =
      name: ''
      type: ''
      attributeConstraint: ''
      isRequired: ''
      sSearchable: ''
      'label.de': ''
      'label.en-US': ''
      enumKey: 'W'
      'enumLabel.en-US': 'female'
      'enumLabel.de': 'weiblich'

    attributeRow3 =
      name: ''
      type: ''
      attributeConstraint: ''
      isRequired: ''
      isSearchable: ''
      'label.de': ''
      'label.en-US': ''
      enumKey: 'U'
      'enumLabel.en-US': 'unisex'
      'enumLabel.de': 'unisex'

    expectedAttributeDefinition =
      gender:
        name: 'gender'
        label:
          de: 'Geschlecht'
          'en-US': 'gender'
        type:
          name: 'lenum'
          values: [{ key: 'M', label: de: 'männlich', 'en-US': 'male' }, { key: 'W', label: de: 'weiblich', 'en-US': 'female' }, { key: 'U', label: de: 'unisex', 'en-US': 'unisex' }]
        attributeConstraint: 'None'
        isRequired: false
        isSearchable: false

    expect(@generator._createAttributeDefinitions([attributeRow1, attributeRow2, attributeRow3])).to.deep.equal expectedAttributeDefinition

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

    expect(@generator._createAttributeDefinitions([attributeRow])).to.deep.equal expectedAttributeDefinition

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

    expect(@generator._createAttributeDefinitions([attributeRow])).to.deep.equal expectedAttributeDefinition


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

    expect(@generator._createAttributeDefinitions([attributeRow])).to.deep.equal expectedAttributeDefinition

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

    expect(@generator._createAttributeDefinitions([attributeRow])).to.deep.equal expectedAttributeDefinition

  it 'should return one attribute definition of type datetime', ->

    attributeRow =
      name: 'releaseTime'
      type: 'datetime'
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
          name: 'datetime'
        attributeConstraint: 'None'
        isRequired: false
        isSearchable: false

    expect(@generator._createAttributeDefinitions([attributeRow])).to.deep.equal expectedAttributeDefinition


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

    expect(@generator._createAttributeDefinitions([attributeRow])).to.deep.equal expectedAttributeDefinition


  it 'should return one attribute definition of type boolean', ->

    attributeRow =
      name: 'isSupported'
      type: 'boolean'
      attributeConstraint: 'None'
      isRequired: 'false'
      isSearchable: 'false'
      'label.de': 'Unterstützt'
      'label.en': 'Supported'

    expectedAttributeDefinition =
      isSupported:
        name: 'isSupported'
        label:
          de: 'Unterstützt'
          en: 'Supported'
        type:
          name: 'boolean'
        attributeConstraint: 'None'
        isRequired: false
        isSearchable: false

    expect(@generator._createAttributeDefinitions([attributeRow])).to.deep.equal expectedAttributeDefinition

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

    expect(@generator._createAttributeDefinitions([attributeRow])).to.deep.equal expectedAttributeDefinition

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
        isRequired: false
        isSearchable: false

    expect(@generator._createAttributeDefinitions([attributeRow])).to.deep.equal expectedAttributeDefinition

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
        isRequired: false
        isSearchable: false

    expect(@generator._createAttributeDefinitions([attributeRow1, attributeRow2])).to.deep.equal expectedAttributeDefinition

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
        isRequired: false
        isSearchable: false

    expect(@generator._createAttributeDefinitions([attributeRow1, attributeRow2])).to.deep.equal expectedAttributeDefinition

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

    expect(@generator._createProductTypesDefinitions(productTypeDefinitions, attributeDefinitions, mastersku)).to.deep.equal expectedProductTypeDefinitions

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

    expect(@generator._createProductTypesDefinitions(productTypeDefinitions, attributeDefinitions, mastersku)).to.deep.equal expectedProductTypeDefinitions

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

    expect(@generator._createProductTypesDefinitions(productTypeDefinitions, attributeDefinitions)).to.deep.equal expectedProductTypeDefinitions

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

    expect(@generator._createProductTypesDefinitions([productTypeDefinition], attributeDefinitions)).to.deep.equal [expectedProductTypeDefinition]

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

    expect(@generator._createAttributeDefinitionMastersku()).to.deep.equal expectedAttributeDefinition

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

    expect(@generator._createAttributeDefinitions([attributeRow])).to.deep.equal expectedAttributeDefinition

  it 'should return an attribute definition of type set:lenum', ->

    attributeRow =
      name: '60048507_einschubfuer',
      type: 'set:lenum',
      attributeConstraint: 'None',
      isRequired: 'false',
      isSearchable: 'true',
      enumKey: '60048507_einschubfuer_ep60059811',
      'enumLabel.nl': 'MM-Card',
      'enumLabel.it': 'MM-Card',
      'enumLabel.fr': 'MMC',
      'enumLabel.de': 'MM-Card',
      'type.referenceTypeId': '',
      'type.typeReference.typeId': '',
      'type.typeReference.id': '',
      'label.en': '',
      'label.nl': 'geïntegreerde deel voor',
      'label.it': 'Slot integrata per',
      'label.fr': 'Slot intégré pour carte(s):',
      'label.de': 'Einschub für',
      textInputHint: 'SingleLine',
      displayGroup: 'Other'

    expectedAttributeDefinition =
      '60048507_einschubfuer':
        name: '60048507_einschubfuer',
        label:
          nl: 'geïntegreerde deel voor',
          en: '',
          it: 'Slot integrata per',
          fr: 'Slot intégré pour carte(s):',
          de: 'Einschub für',
        type:
          name: 'set',
          elementType:
            name: 'lenum',
            values:
              [
                key: '60048507_einschubfuer_ep60059811',
                label: { nl: 'MM-Card', it: 'MM-Card', fr: 'MMC', de: 'MM-Card' }
              ]
        attributeConstraint: 'None',
        isRequired: false,
        isSearchable: true

    expect(@generator._createAttributeDefinitions([attributeRow])).to.deep.equal expectedAttributeDefinition

  it 'should split and return attribute element type or ettribute type', ->

    expect(@generator._typeOrElementType('set:set:type')).to.deep.equal 'set:type'
    expect(@generator._typeOrElementType('set:type')).to.deep.equal 'type'
    expect(@generator._typeOrElementType('type')).to.deep.equal 'type'

  it 'should split and return attribute type', ->

    expect(@generator._type('set:set:type')).to.deep.equal 'set'
    expect(@generator._type('set:type')).to.deep.equal 'set'
    expect(@generator._type('type')).to.deep.equal 'type'
