Subjects = require 'collections/external_subjects'
Params = require 'collections/params'
describe 'External Subjects', ->
  beforeEach ->
    @params = new Params [
      {key: 'ra', val: 177.7}
      {key: 'dec', val: 0.0}
    ]
    @subjects = new Subjects [], {url: '/testing', params: @params}

  it 'should be instantiable', ->
    expect(@subjects).to.be.defined

  it 'should throw an error if no URL is provided', ->
    fn = -> new Subjects
    expect(fn).to.throw()

  describe "#processParams", =>
    it 'should create a query string from params', ->
      expect(@subjects.processParams()).to.be("ra=177.7&dec=0.0")

  describe '#url', ->
    beforeEach ->
      @url = @subjects.url()
    it 'should return a valid string', ->
      expect(@url).to.be.a('string')
        .and.not.contain('undefined')

