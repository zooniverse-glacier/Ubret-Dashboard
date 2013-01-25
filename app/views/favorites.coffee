MyDataLists = require 'views/my_data_lists'
Collection = require 'collections/favorites'

class Favorites extends MyDataLists
  className: 'my-data favorites'
  template: require './templates/favorite_list'
  templateItem: require './templates/recent'
  collectionClass: Collection


module.exports = Favorites


