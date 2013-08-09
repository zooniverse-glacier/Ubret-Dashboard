class Param extends Backbone.AssociatedModel
  
  evaluate: =>
    for key, value of @attributes when _.isFunction(value)
      @set(key, value())

  isValid: =>
    if @get('required')
      val = @get('val')
      if _.isUndefined(val) or val is ""
        false
      else
        validation = @get('validation')
        if _.isUndefined(validation)
          true
        else if _.isString(validation)
          true
        else if _.isFunction(validation)
          validation(val)
        else if _.isArray(validation)
          validation[0] < val and validation[1] > val
    else
      true
      
  toJSON: =>
    @pick('key', 'val')

module.exports = Param