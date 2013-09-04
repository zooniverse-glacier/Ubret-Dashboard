exports.config =
  files:
    javascripts:
      joinTo:
        'js/app.js': /^app/
        'js/vendor.js': /^(bower_components|vendor)/

    stylesheets:
      joinTo: 
        'css/app.css' : /^(bower_components|vendor|app\/styles)/

    templates:
      joinTo: 'javascripts/app.js'