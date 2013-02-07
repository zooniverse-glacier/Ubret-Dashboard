exports.config =
  files:
    javascripts:
      joinTo:
        'javascripts/app.js': /^app/
        'javascripts/vendor.js': /^vendor/
        'test/javascripts/test.js': /^test(\/|\\)(?!vendor)/
        'test/javascripts/test-vendor.js': /^test(\/|\\)(?=vendor)/
      order:
        before: [
          'vendor/scripts/jquery-1.8.2.js',
          'vendor/scripts/underscore-1.4.2.js',
          'vendor/scripts/backbone-0.9.10.js',
          'vendor/scripts/backbone-mediator.js',
          'vendor/scripts/backbone-associations.js',
          'test/vendor/scripts/mocha-1.4.2.js',
          'test/vendor/scripts/chai.js',
          'test/vendor/scripts/sinon-1.5.2.js',
          'test/vendor/scripts/sinon-chai-2.1.2.js',
          'test/vendor/scripts/chai-jquery.js',
          'test/vendor/scripts/backbone-0.9.10.js',
          'test/vendor/scripts/backbone-mediator.js'
        ]

    stylesheets:
      defaultExtension: 'styl'
      joinTo:
        'stylesheets/app.css': /^app\/styles\/index.styl/
        'stylesheets/vendor.css' : /^vendor/
        'test/stylesheets/test.css': /^test/
      order:
        before: [
          'vendor/styles/leaflet.css'
        ]
        after: []

    templates:
      joinTo: 'javascripts/app.js'
