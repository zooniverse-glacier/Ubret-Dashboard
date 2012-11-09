Filter = require 'models/filter'

describe 'filter', ->
  it 'should be defined', ->
    expect(Filter).to.be.ok

  it 'should be instantiable', ->
    filter = new Filter
    expect(filter).to.be.ok

  describe '::lexer', ->
    describe 'one filter', ->
      it 'should accept a string and return an array of hash of symbols', ->
        string = 'petrosian radius is less than 10'
        expect(Filter.lexer(string)[0]).to.have.property('variable').and.equal('petrosian radius')
        string = 'dec > 4'
        expect(Filter.lexer(string)[0]).to.have.property('comparator').and.equal('>')
        string = 'dec is not equal to 10'
        expect(Filter.lexer(string)[0]).to.have.property('negation').and.equal(true)
        string = 'dec equals 1.4'
        expect(Filter.lexer(string)[0]).to.have.property('number').and.equal(1.4)

    describe 'multiple filters', ->
      it 'should accept a string a return an array of hash of symbols', ->
        string = 'petrosian radius > 4 and dec equals 2 or ra is not equal to 1.0'
        filters = Filter.lexer(string)
        expect(filters).to.have.length(3)
        expect(filters[0]).to.have.property('conjunction').and.equal('and')
        expect(filters[1]).to.have.property('number').and.equal(2)
