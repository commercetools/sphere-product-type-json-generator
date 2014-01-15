ProductTypeGenerator = require('../main').ProductTypeGenerator

describe 'ProductTypeGenerator', ->
  beforeEach ->
    @generator = new ProductTypeGenerator('foo')
    console.log "test1 #{@generator}"

  it 'should initialize', ->
    console.log "test2 #{@generator}"
    expect(@generator).toBeDefined()

  it 'should initialize with options', ->
    console.log "test3 #{@generator}"
    expect(@generator._options).toBe 'foo'