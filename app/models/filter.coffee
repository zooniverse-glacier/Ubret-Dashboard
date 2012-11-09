class Filter extends Backbone.Model
  @lexerRegExp: /((?:\w+)?(?:\s)?\w+)(?: is )?(not )?(less |greater |equal |equals )?( >=| <=| >| <| !=| =|than|to)?\s(\d+|\d+\.\d+)\s?(and|or|$)/g

  @lexer: (string) =>
    filters = new Array
    string.replace(@lexerRegExp, (match, args...) ->
      filter = new Object 
      for arg, i in args when arg isnt ''
        arg = arg.trim() if typeof arg is 'string'
        filter['variable'] = arg if i is 0
        filter['negation'] = true if arg is 'not'
        filter['comparator'] = arg if arg in ['less', 'equal', 'equal', 'greater', '>', '<', '<=', '>=', '!=', '=']
        filter['number'] = parseFloat(arg) if i is 4
        filter['conjunction'] = arg if arg in ['and', 'or']
      filters.push filter)
    return filters

module.exports = Filter
