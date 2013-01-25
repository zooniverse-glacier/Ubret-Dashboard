MyDataLists = require 'views/my_data_lists'
Collection = require 'collections/recents'

class Recents extends MyDataLists
  className: 'my-data-recents'
  template: require './templates/recent_list'
  templateItem: require './templates/recent'
  collectionClass: Collection
  
module.exports = Recents
