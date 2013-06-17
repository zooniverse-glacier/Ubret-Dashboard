MyDataLists = require 'views/my_data_lists'

class Recents extends MyDataLists
  className: 'my-data recents'
  template: require './templates/recent_list'
  templateItem: require './templates/recent'
  type: 'recent'
  name: 'recents'
  
module.exports = Recents
