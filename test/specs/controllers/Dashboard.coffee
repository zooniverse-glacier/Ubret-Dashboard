require = window.require

describe 'Dashboard', ->
  $ = require('jqueryify')
  Spine = require('spine')
  ToolWindow = require('controllers/ToolWindow')
  Dashboard = require('controllers/Dashboard')
  BaseController = require('ubret/lib/controllers/BaseController')
  Table         = require('ubret/lib/controllers/Table')
  GalaxyZooSubject = require('ubret/lib/models/GalaxyZooSubject')

  beforeEach ->

    @dashboard = new Dashboard({el: ".dashboard"})
    @tool = sinon.stub(new BaseController)

  describe "#addTool", ->
    beforeEach ->
      spyOn(@dashboard, 'createWindow')
      @dashboard.tools = new Array
      @dashboard.channels = new Array
      @dashboard.addTool @tool

    it 'should add a new Tool to the Dashboard', ->
      expect(@dashboard.tools[0]).toBe @tool

    it 'should add the Tool\'s publish channel to the list of published channels', ->
      expect(@dashboard.channels[0]).toBe @tool.channel

    it 'should call #createWindow', ->
      expect(@dashboard.createWindow).toHaveBeenCalled()

  describe "#createTool", ->
    beforeEach ->
      #spyOn(BaseController, 'constructor')
      #spyOn(@dashboard, 'append')
      #@dashboard.createTool BaseController

    it 'should call the new Tool\'s constructor', ->
      #expect(BaseController.constructor).toHaveBeenCalled()

    it 'should create a new div for the added Tool', ->
      #expect(@dashboard.append).toHaveBeenCalled()

  describe "#removeTool", ->
    beforeEach ->
      numTools = 5
      @dashboard.tools = new Array
      @dashboard.channels = new Array
      for i in [1..5]
        @dashboard.createTool Table

      @tool = @dashboard.tools[2]
      @dashboard.removeTool @tool

    it 'should remove the specified tool from the list of published channels', ->
      expect(@dashboard.channels).not.toContain @tool.channel

    it 'should remove the specified tool from the dashboard', ->
      expect(@dashboard.tools).not.toContain @tool

    afterEach ->
      @dashboard.removeTools()

  describe "#removeTools", ->
    beforeEach ->
      spyOn(@dashboard, 'removeTool')
      numTools = 5
      for i in [1..5]
        @dashboard.createTool Table
      @dashboard.removeTools()

    it 'should call removeTool for each tool on the dashboard', ->
      expect(@dashboard.removeTool.calls.length).toEqual(5)

    it 'should empty the workspace', ->
      expect($('#{@dashboard.workspace}').html()).toBeNull()

