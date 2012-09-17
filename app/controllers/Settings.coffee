Spine = require('spine')

class Settings extends Spine.Controller
  constructor: ->
    super
    @source

  events:
    'click .data-sources li': 'onDataSourceSelection'
    submit: 'onSubmit'

  elements: 
    '.source-choices'      : 'sourceDataBox'
    '.data-points'         : 'dataPoints'
    '.submit'              : 'submit'
    'input[name="params"]' : 'params'

  className: "settings"

  template: require('views/settings')

  render: =>
    @html @template(@)
    
  onDataSourceSelection: (e) =>
    @source = $(e.currentTarget).data('source')

    @sourceDataBox.empty()
    switch @source
      when "api" then @sourceDataBox.append(require('views/settings-options-sources')(@))
      when "channel" then @sourceDataBox.append(require('views/settings-options-channels')(@))
    @sourceDataBox.parent().show()
    @dataPoints.show()
    @submit.show()

  onSubmit: (e) =>
    e.preventDefault()
    unless @source == 'channel'
      params = @params.val()
    source = @sourceDataBox.val()
    @$el.parent().toggleClass 'settings-active'
    @tool.bindTool source, params

module.exports = Settings