BaseView = require 'views/base_view'

class SpacewarpViewerSettings extends BaseView
  className: 'spacewarp-viewer-settings'
  template: require 'views/templates/settings/spacewarp_viewer'
  
  events:
    'click input[name="band"]'    : 'onBandChange'
    'change input[name="alpha"]'  : 'onAlphaChange'
    'change input[name="Q"]'      : 'onQChange'
    'change input.scale'          : 'onScaleChange'
    'change select.stretch'       : 'onStretchChange'
    'change input.extent'         : 'onExtentChange'
    'click .reset'                : 'onReset'
  
  
  initialize: =>
    @model.tool.on 'swviewer:loaded', =>
      @render()
      
      opts = @model.tool.opts
      @model.tool.on 'next', @next
      @model.tool.on 'prev', @prev
      
      # Update UI elements
      inputs = @$el.find('input[type="range"]')
      inputs.filter("[name='alpha']").val(opts.alpha)
      inputs.filter("[name='q']").val(opts.q)
      
      inputs.filter("[name='i']").val(opts.scales[0])
      inputs.filter("[name='r']").val(opts.scales[1])
      inputs.filter("[name='g']").val(opts.scales[2])
      
      inputs.filter("[name='min']").val(opts.sliderMin)
      inputs.filter("[name='max']").val(opts.sliderMax)
  
  render: =>
    subject = @model.tool.currentPageData()[0]
    
    @$el.html @template
      cid: @cid 
      alpha: @model.get('settings.alpha')
      q: @model.get('settings.q')
      cftid: subject?.metadata?.id or null
      scale: @model.get('settings.scales')
    
    @qEl or= @$("input[name='q']")
    @alphaEl or= @$("input[name='alpha']")
    
    @iScale or= @$('.scale[name="i"]')
    @rScale or= @$('.scale[name="r"]')
    @gScale or= @$('.scale[name="g"]')
    
    @
  
  next: =>
    @render()
  
  prev: =>
    @render()
  
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
    @render()
  
  onAlphaChange: (e) =>
    alpha = {alpha: e.currentTarget.value}
    @model.tool.settings(alpha)
    @render()
    
  onQChange: (e) =>
    q = {q: e.currentTarget.value}
    @model.tool.settings(q)
    @render()
  
  onScaleChange: ({target}) =>
    {className, value} = target
    className = className.split(" ")[1]
    value = parseFloat(value)
    scales = @model.get('settings.scales')
    if className is 'red'
      scales[0] = value
    else if className is 'green'
      scales[1] = value
    else if className is 'blue'
      scales[2] = value
    @model.tool.settings({scales: scales})
    @render()
  
  onStretchChange: (e) =>
    stretch = {stretch: e.target.value}
    @model.tool.settings(stretch)
    @render()
  
  onExtentChange: (e) =>
    min = @$el.find('[name="min"]').val()
    max = @$el.find('[name="max"]').val()
    
    @model.tool.settings({sliderMin: min, sliderMax: max})
    
    # Scale to gMin and gMax
    opts = @model.tool.opts
    gMin = opts.gMin
    gMax = opts.gMax
    
    gRange = gMax - gMin
    
    min = gRange * min / 1000 + gMin
    max = gRange * max / 1000 + gMin
    
    extent =
      extent:
        min: min
        max: max
    @model.tool.settings(extent)
    @render()

  onReset: (e) =>
    {SpacewarpViewer} = require 'config/tool_config'
    defaults = SpacewarpViewer.defaults
    
    scales = defaults.scales
    q = defaults.q
    alpha = defaults.alpha
    
    @iScale.val(scales[0])
    @rScale.val(scales[1])
    @gScale.val(scales[2])
    @onScaleChange()
    
    @qEl.val(q)
    @alphaEl.val(alpha)
    
    params = {q: q, alpha: alpha}
    @model.tool.settings(params)
    @render()


module.exports = SpacewarpViewerSettings