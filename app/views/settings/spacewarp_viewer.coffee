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
    @model.tool.on 'next', =>
      @render()
  
  render: =>
    subject = @model.tool.currentPageData()[0]
    extent = @model.get('settings.extent') 
    unless extent? 
      if @model.tool.ready
        extent = {min: @scaleExtent(0), max: @scaleExtent(1000)}
      else
        extent = {min: 0, max: 0}
    
    @$el.html @template
      cid: @cid 
      alpha: @model.get('settings.alpha')
      q: @model.get('settings.q')
      cftid: subject?.metadata?.id or null
      scale: @model.get('settings.scales')
      band: @model.tool.opts.band
      extent: extent
      minSlider: @model.get('settings.sliderMin') or 0
      maxSlider: @model.get('settings.sliderMax') or 1000
      stretch: @model.get('settings.stretch')
    
    @qEl or= @$("input[name='q']")
    @alphaEl or= @$("input[name='alpha']")
    
    @iScale or= @$('.scale[name="i"]')
    @rScale or= @$('.scale[name="r"]')
    @gScale or= @$('.scale[name="g"]')


    @$('[data-band="' + @model.get('settings.band') + '"]').prop('checked', true)
    
    @
  
  next: =>
    @render()
  
  prev: =>
    @render()
  
  onBandChange: (e) =>
    band = e.target.dataset.band
    
    # Show and hide appropriate UI elements
    @model.tool.settings({band: band})
    @render()
  
  onAlphaChange: (e) =>
    alpha = {alpha: parseFloat(e.currentTarget.value)}
    @model.tool.settings(alpha)
    @render()
    
  onQChange: (e) =>
    q = {q: parseFloat(e.currentTarget.value)}
    @model.tool.settings(q)
    @render()
  
  onScaleChange: (e) =>
    return unless e?
    {className, value} = e.target
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
  
  onExtentChange: (e) =>
    min = parseInt(@$('[name="min"]').val())
    max = parseInt(@$('[name="max"]').val())
    
    @model.tool.settings({sliderMin: min, sliderMax: max})
    
    extent =
      extent:
        min: @scaleExtent(min)
        max: @scaleExtent(max) 
    @model.tool.settings(extent)
    @render()

  onReset: (e) =>
    {SpacewarpViewer} = require 'config/tool_config'
    defaults = SpacewarpViewer.defaults
    
    scales = _.clone(defaults.scales)
    q = defaults.q
    alpha = defaults.alpha
   
    @iScale.val(scales[0])
    @rScale.val(scales[1])
    @gScale.val(scales[2])
    
    @qEl.val(q)
    @alphaEl.val(alpha)
  
    @model.tool.settings({band: 'gri', q: q, alpha: alpha, scales: scales})
    @render()

  scaleExtent: (ex) =>
    # Scale to gMin and gMax
    {gMin, gMax} = @model.tool.opts
    gRange = gMax - gMin
    gRange * (ex / 1000) + gMin

module.exports = SpacewarpViewerSettings