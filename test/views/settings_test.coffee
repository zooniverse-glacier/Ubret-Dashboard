Settings = require 'views/settings'

describe 'Settings', ->
  beforeEach ->
    @setting = new Settings {model: new Backbone.Model {tool_type: 'Table', id: 1}}

  it 'should be instantiable', ->
    expect(@setting).to.be.ok


