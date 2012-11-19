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
          'vendor/scripts/backbone-0.9.2.js',
          'vendor/scripts/backbone-mediator.js',
          'vendor/scripts/sizzle.js',
          'vendor/scripts/d3.v2.js',
          'vendor/scripts/leaflet.js',
          'test/vendor/scripts/mocha-1.4.2.js',
          'test/vendor/scripts/chai.js',
          'test/vendor/scripts/sinon-1.4.2.js',
          'test/vendor/scripts/sinon-chai-2.1.2.js',
          'test/vendor/scripts/chai-jquery'
        ]

    stylesheets:
      joinTo:
        'stylesheets/app.css': /^app\/styles\/index.styl/
        'test/stylesheets/test.css': /^test/
      order:
        before: [
          'vendor/styles/leaflet.css'
        ]
        after: []

    templates:
      joinTo: 'javascripts/app.js'
