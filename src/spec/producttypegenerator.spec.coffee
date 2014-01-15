ProductTypeGenerator = require('../lib/producttypegenerator').ProductTypeGenerator

describe 'ProductTypeGenerator', ->
  beforeEach ->
    @generator = new ProductTypeGenerator('foo')

  it 'should initialize', ->
    expect(@generator).toBeDefined()

  it 'should initialize with options', ->
    expect(@generator._options).toBe 'foo'