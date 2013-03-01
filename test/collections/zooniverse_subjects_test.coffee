Subjects = require ('collections/zooniverse_subjects')
Params = require 'collections/params'

describe 'Zooniverse Subjects', ->
  beforeEach ->
    @paramsId = new Params [{key: 'id', val: '1'}]
    @paramsFavs = new Params [{key: 'limit', val: 20}]

    @idSubjects = new Subjects [],
      params: @paramsId
      search_type: 0
      url: -> '/funtimes'

    @favsSubjects = new Subjects [],
      params: @paramsFavs
      search_type: 2
      url: -> '/favtimes'

    @favsSubjects.manager.set 'project', 'galaxy_zoo'
    @idSubjects.manager.set 'project', 'galaxy_zoo'

  it 'should be instantiable', ->
    expect(@favsSubjects).to.be.defined
    expect(@idSubjects).to.be.defined

  it 'should set the base url function', ->
    expect(@favsSubjects).to.have.property('base')
      .and.be.a('function')
    expect(@idSubjects).to.have.property('base')
      .and.be.a('function')

  it 'should set the type of search', ->
    expect(@favsSubjects).to.have.property('type')
      .and.equal(2)
    expect(@idSubjects).to.have.property('type')
      .and.equal(0)

  context 'when searching by id', ->
    it 'should set @id', ->
      expect(@idSubjects).to.have.property('id')
        .and.equal('1')
      expect(@favsSubjects).to.not.have.property('id')

  context 'when search for favorites or recents', ->
    it 'should create a params object', ->
      expect(@favsSubjects).to.have.property('params')
        .and.be.an('object')
      expect(@idSubjects).not.to.have.property('params')

  describe '#url', ->
    context 'when searching by id', ->
      it 'should call base with @id', ->
        baseSpy = sinon.spy(@idSubjects, 'base')
        @idSubjects.url()
        expect(baseSpy).to.have.been.calledWith(@idSubjects.id)

      it 'should return a string', ->
        expect(@idSubjects.url()).to.equal("/funtimes")

    context 'when search for favorites or recents', ->
      context 'when a user is logged in', ->
        beforeEach ->
          @favsSubjects.user = 
            current: {id: 1, apiToken: 2}
          @processSpy = sinon.spy(@favsSubjects, 'processParams')
          @baseSpy = sinon.spy(@favsSubjects, 'base')
          @url = @favsSubjects.url()

        it 'should call base with user id', ->
          expect(@baseSpy).to.have.been.calledWith(@favsSubjects.user.id)

        it 'should call process params', ->
          expect(@processSpy).to.have.been.called

        it 'should return a string', ->
          expect(@url).to.equal("/favtimes?per_page=20")

      context 'when a user is not logged in', ->
        it 'should throw an error', ->
          expect(@favsSubjects.url).to.throw()

  describe '#processParams', ->
    it 'should turn params object into a query string', ->
      @favsSubjects.params = {test: "test", hi: "there"}
      expect(@favsSubjects.processParams()).to.equal("test=test&hi=there")

    context "a param is called limit", ->
      it "should rename param per_page", ->
        expect(@favsSubjects.processParams()).to.equal("per_page=20")


  describe '#parse', ->
    context 'when a project has a parsing function defined', ->
      it 'should call that function', ->
        gzSpy = sinon.stub(@idSubjects, 'galaxy_zoo')
        @idSubjects.manager.set 'project', 'galaxy_zoo'
        @idSubjects.parse({})
        expect(gzSpy).to.have.been.called

  describe '#galaxy_zoo', ->
    it 'should format an ouroboros subject for the dashboard', ->
      object = 
        zooniverse_id: 1
        location:
          standard: 1
          thumbnail: 1
        coords: [1, 2]
        metadata:
          absolute_size: 1
          petrorad_50_r: 1
          redshfit: 1
          sdss_id: 2

       result = @idSubjects.galaxy_zoo object
       expect(result).to.have.property('ra')
         .and.equal(1)
       expect(result).to.have.property('dec')
         .and.equal(2)


