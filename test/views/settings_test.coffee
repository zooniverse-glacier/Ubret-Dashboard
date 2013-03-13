Settings = require 'views/settings'

describe 'Settings', ->
  beforeEach ->
    @setting = new Settings 
      model: new Backbone.Model {tool_type: 'Table', id: 1}
      config: 
        'Table': 
          settings: [Backbone.View]
                  

  it 'should be instantiable', ->
    expect(@setting).to.be.ok

  it 'should create a setting view for each setting in the config', ->
    expect(@setting).to.have.property('toolSettings').and.have.length(1)

  describe '#render', ->
    beforeEach ->
      @setting.model.set 'settings_active', true
      @setting.render()

    context 'window is hidden', ->
      beforeEach ->
        @setting.model.set 'settings_active', false

      it 'should not have the class active', ->
        @setting.render()
        expect(@setting.$el).to.not.have.class 'active'

      it 'should call remove on each setting in toolSettings', ->
        settingSpy = sinon.spy(@setting.toolSettings[0], 'remove')
        @setting.render()
        expect(settingSpy).to.have.been.called

    context 'window is visible', ->
      it 'should set the window\'s class to active', ->
        expect(@setting.$el).to.have.class 'active'

      it 'should render the tool settings and call delegate events', ->
        renderSpy = sinon.spy(@setting.toolSettings[0], 'render')
        delegateSpy = sinon.spy(@setting.toolSettings[0], 'delegateEvents')
        @setting.render()
        expect(renderSpy).to.have.been.called
        expect(delegateSpy).to.have.been.called

  describe 'event handlers', ->
    beforeEach ->
      @setting.model.tool = {trigger: (-> 'hi')}
      @triggerSpy = sinon.spy(@setting.model.tool, 'trigger')

    describe '#toggleState', ->
      it 'should update the state of settings_active on the model', ->
        @setting.model.updateFunc = @setting.model.set
        @setting.model.set 'settings_active', true
        @setting.toggleState()
        expect(@setting.model.get('settings_active')).to.be.false
        @setting.toggleState()
        expect(@setting.model.get('settings_active')).to.be.true

    describe '#next', ->
      it 'should trigger next event on the model', ->
        @setting.next()
        expect(@triggerSpy).to.have.been.calledWith('next')

    describe '#prev', ->
      it 'should trigger previous events on the model', ->
        @setting.prev()
        expect(@triggerSpy).to.have.been.calledWith('prev')
