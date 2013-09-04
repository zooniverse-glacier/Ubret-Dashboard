exports.config =
  files:
    javascripts:
      joinTo:
        'js/app.js': /^app/
        'js/vendor.js': /^(bower_components|vendor)/

    stylesheets:
      defaultExtension: 'css'
      joinTo: 
        'css/app.css' : /^styles/
        'css/vendor.css' : /^(bower_components|vendor)/

    templates:
      joinTo: 'javascripts/app.js'