exports.config =
  # See http://brunch.readthedocs.org/en/latest/config.html for documentation.
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
          'vendor/scripts/jquery.simpleWeather.js'
        ]
        before: [
          'test/vendor/scripts/mocha-1.4.2.js',
          'test/vendor/scripts/chair.js',
          'test/vendor/scripts/sinon-1.4.2.js',
          'test/vendor/scripts/sinon-chair-2.1.2.js'
        ]

    stylesheets:
      joinTo:
        'stylesheets/app.css': /^(app|vendor)/
        'test/stylesheets/test.css': /^test/
      order:
        before: []
        after: []

    templates:
      joinTo: 'javascripts/app.js'
