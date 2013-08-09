class Param extends Backbone.AssociatedModel
  
  evaluate: =>
    for key, value of @attributes when _.isFunction(value)
      @set(key, value()) unless key is 'validation'

  isValid: =>
    val = @get('val')
    if @get('required') and (_.isUndefined(val) or val is "")
      false
    else
      validation = @get('validation')
      if _.isUndefined(validation)
        true
      else if _.isString(validation)
        true
      else if _.isFunction(validation)
        validation(val, @collection)
      else if _.isArray(validation)
        validation[0] < val and validation[1] > val
      
  toJSON: =>
    @pick('key', 'val')

module.exports = Param