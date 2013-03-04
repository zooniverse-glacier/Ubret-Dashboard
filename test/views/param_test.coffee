Param = require 'views/param'
ParamModel = require 'models/param'

describe 'Param View', ->
  beforeEach -> 
    @param = new Param
      model: new ParamModel

  it 'should be instantiable', ->
    expect(@param).to.be.defined

  it 'should throw and error if not passed a model', ->
    fn = -> new Param
    expect(fn).to.throw()

  describe '#render', ->
    it 'should render template to $el html', ->
      @param.template = -> 'noop'
      htmlSpy = sinon.spy(@param.$el, 'html')
      tempSpy = sinon.spy(@param, 'template')
      @param.render()
      expect(htmlSpy).to.have.been.called
      expect(tempSpy).to.have.been.calledWith(@param.model)

  describe '#setState', ->
    it 'should set the current value of the param', ->
      sinon.stub(@param, "getCurrentValue").returns "test"
      @param.setState()
      expect(@param.model.get('val')).to.eq("test")

  describe '#getCurrentValue', ->
    it 'should get the value of the element with a data-cid attr', ->
      @param.template = (model) -> """
        <input data-cid="#{model.cid}" value="test" type="text" />
      """
      @param.render()
      expect(@param.getCurrentValue()).to.eq("test")
