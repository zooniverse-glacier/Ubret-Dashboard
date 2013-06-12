BaseView = require 'views/base_view'

class SpacewarpViewerSettings extends BaseView
  className: 'spacewarp-viewer-settings'
  template: require 'views/templates/settings/spacewarp_viewer'
  
  events:
    'click input[name="band"]'      : 'onBandChange'
    'change input[name="alpha"]'    : 'onAlphaChange'
    'change input[name="Q"]'        : 'onQChange'
    'change input.scale'            : 'onScaleChange'
    'change input[name="stretch"]'  : 'onStretchChange'
    'change input.extent'           : 'onExtentChange'
  
  
  initialize: =>
    @model.once 'started', =>
      @model.tool.on 'swviewer:loaded', =>
        @$el.find('#gri').click()
  
  render: =>
    @$el.html @template 
      cid: @cid 
      alpha: @model.get('settings.alpha')
      q: @model.get('settings.q')
      
    @iScale = @$('.scale[name="i"]')
    @rScale = @$('.scale[name="r"]')
    @gScale = @$('.scale[name="g"]')
    
    @
  
  onBandChange: (e) =>
    band = e.currentTarget.dataset.band
    
    color = @$el.find('.parameters.color')
    gray  = @$el.find('.parameters.grayscale')
    
    # Show and hide appropriate UI elements
    if band is 'gri'
      color.show()
      gray.hide()
    else
      color.hide()
      gray.show()
   
    setting = {band: band}
    @model.tool.settings(setting)
  
  onAlphaChange: (e) =>
    alpha = {alpha: e.currentTarget.value}
    @model.tool.settings(alpha)
    
  onQChange: (e) =>
    q = {q: e.currentTarget.value}
    @model.tool.settings(q)
  
  onScaleChange: (e) =>
    scales = { scales: [@iScale.val(), @rScale.val(), @gScale.val()] }
    @model.tool.settings(scales)
  
  onStretchChange: (e) =>
    stretch = {stretch: e.currentTarget.dataset.function}
    @model.tool.settings(stretch)
  
  onExtentChange: (e) =>
    extent =
      extent:
        min: @$el.find('[name="min"]').attr('value')
        max: @$el.find('[name="max"]').attr('value')
    @model.tool.settings(extent)


module.exports = SpacewarpViewerSettings
