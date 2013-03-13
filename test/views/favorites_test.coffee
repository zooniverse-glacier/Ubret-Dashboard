itShouldBehaveLikeAMyDataList = require './my_data_list_test'
Favorites = require 'views/favorites'

describe 'Favorites List', ->
  beforeEach ->
    @list = new Favorites

  itShouldBehaveLikeAMyDataList()
