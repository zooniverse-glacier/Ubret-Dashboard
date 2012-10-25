chai = require 'chai'
sinonChai = require 'sinon-chai'
chai.use sinonChai

module.exports =
  expect: chai.expect
  sinon: require 'sinon'