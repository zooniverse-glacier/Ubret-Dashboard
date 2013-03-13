itShouldBehaveLikeAMyDataList = require './my_data_list_test'
Recents = require 'views/recents'

describe 'Recents List', ->
  beforeEach ->
    @list = new Recents

  itShouldBehaveLikeAMyDataList()