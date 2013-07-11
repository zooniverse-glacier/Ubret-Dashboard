class Params extends Backbone.Collection
  model: require 'models/param'

  isValid: =>
    return false if @length is 0
    valid = _.uniq(@map (p) -> p.isValid())
    valid.length is 1 and valid[0]
    
  toHash: =>
    @chain().map((i) -> [i.get('key'),i.get('val')]).object().value()
  
module.exports = Params