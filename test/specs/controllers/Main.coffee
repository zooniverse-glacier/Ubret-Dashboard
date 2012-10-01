require = window.require

describe 'Main', ->
  Main = require('controllers/Main')
  
  beforeEach ->
    @Main = new Main

  it 'noop', ->

    