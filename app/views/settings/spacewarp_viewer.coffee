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
    @model.tool.on 'swviewer:loaded', =>
      
      opts = @model.tool.opts
      if opts.band?
        @$el.find("##{opts.band}-#{@cid}").click()
      else
        @$el.find("#gri-#{@cid}").click()
        
      if opts.stretch?
        @$el.find("##{opts.stretch}-#{@cid}").click()
      else
        @$el.find("#linear-#{@cid}").click()
      
      # Update UI elements
      inputs = @$el.find('input[type="range"]')
      inputs.filter("[name='alpha']").val(opts.alpha) if opts.alpha?
      inputs.filter("[name='q']").val(opts.q) if opts.q?
      if opts.scales?
        inputs.filter("[name='i']").val(opts.scales[0])
        inputs.filter("[name='r']").val(opts.scales[1])
        inputs.filter("[name='g']").val(opts.scales[2])
      
      inputs.filter("[name='min']").val(opts.sliderMin or 0)
      inputs.filter("[name='max']").val(opts.sliderMax or 1000)
  
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
    scales =
      scales:
        i: @iScale.val()
        r: @rScale.val()
        g: @gScale.val()
    scales = { scales: [@iScale.val(), @rScale.val(), @gScale.val()] }
    @model.tool.settings(scales)
  
  onStretchChange: (e) =>
    stretch = {stretch: e.currentTarget.dataset.function}
    @model.tool.settings(stretch)
  
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


module.exports = SpacewarpViewerSettings
