(function(/*! Brunch !*/) {
  'use strict';

  var globals = typeof window !== 'undefined' ? window : global;
  if (typeof globals.require === 'function') return;

  var modules = {};
  var cache = {};

  var has = function(object, name) {
    return ({}).hasOwnProperty.call(object, name);
  };

  var expand = function(root, name) {
    var results = [], parts, part;
    if (/^\.\.?(\/|$)/.test(name)) {
      parts = [root, name].join('/').split('/');
    } else {
      parts = name.split('/');
    }
    for (var i = 0, length = parts.length; i < length; i++) {
      part = parts[i];
      if (part === '..') {
        results.pop();
      } else if (part !== '.' && part !== '') {
        results.push(part);
      }
    }
    return results.join('/');
  };

  var dirname = function(path) {
    return path.split('/').slice(0, -1).join('/');
  };

  var localRequire = function(path) {
    return function(name) {
      var dir = dirname(path);
      var absolute = expand(dir, name);
      return globals.require(absolute);
    };
  };

  var initModule = function(name, definition) {
    var module = {id: name, exports: {}};
    definition(module.exports, localRequire(name), module);
    var exports = cache[name] = module.exports;
    return exports;
  };

  var require = function(name) {
    var path = expand(name, '.');

    if (has(cache, path)) return cache[path];
    if (has(modules, path)) return initModule(path, modules[path]);

    var dirIndex = expand(path, './index');
    if (has(cache, dirIndex)) return cache[dirIndex];
    if (has(modules, dirIndex)) return initModule(dirIndex, modules[dirIndex]);

    throw new Error('Cannot find module "' + name + '"');
  };

  var define = function(bundle) {
    for (var key in bundle) {
      if (has(bundle, key)) {
        modules[key] = bundle[key];
      }
    }
  }

  globals.require = require;
  globals.require.define = define;
  globals.require.brunch = true;
})();

window.require.define({"application": function(exports, require, module) {
  (function() {



  }).call(this);
  
}});

window.require.define({"collections/galaxy_zoo_subjects": function(exports, require, module) {
  (function() {
    var GalaxyZooSubject, GalaxyZooSubjects,
      __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
      __hasProp = {}.hasOwnProperty,
      __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

    GalaxyZooSubject = require('models/galaxy_zoo_subject');

    GalaxyZooSubjects = (function(_super) {

      __extends(GalaxyZooSubjects, _super);

      function GalaxyZooSubjects() {
        this.processParams = __bind(this.processParams, this);

        this.url = __bind(this.url, this);
        return GalaxyZooSubjects.__super__.constructor.apply(this, arguments);
      }

      GalaxyZooSubjects.prototype.initialize = function(models, options) {
        var key, value, _ref, _results;
        if (models == null) models = [];
        if (options == null) options = {};
        _ref = options.params;
        _results = [];
        for (key in _ref) {
          value = _ref[key];
          _results.push(this.params[key] = value);
        }
        return _results;
      };

      GalaxyZooSubjects.prototype.params = {
        limit: 10
      };

      GalaxyZooSubjects.prototype.model = GalaxyZooSubject;

      GalaxyZooSubjects.prototype.url = function() {
        return "/gz_subjects?" + (this.processParams());
      };

      GalaxyZooSubjects.prototype.processParams = function() {
        var key, params, value, _ref;
        params = new Array;
        _ref = this.params;
        for (key in _ref) {
          value = _ref[key];
          params.push("" + key + "=" + value);
        }
        return params.join('&');
      };

      return GalaxyZooSubjects;

    })(Backbone.Collection);

    module.exports = GalaxyZooSubjects;

  }).call(this);
  
}});

window.require.define({"initialize": function(exports, require, module) {
  (function() {
    var Table, application;

    application = require('application');

    Table = require('ubret/lib/controllers/Table');

    $(function() {
      console.log(Table);
      application.initialize();
      return Backbone.history.start();
    });

  }).call(this);
  
}});

window.require.define({"models/data_source": function(exports, require, module) {
  (function() {
    var DataSource, GalaxyZooSubjects,
      __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
      __hasProp = {}.hasOwnProperty,
      __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

    GalaxyZooSubjects = require('collections/galaxy_zoo_subjects');

    DataSource = (function(_super) {

      __extends(DataSource, _super);

      function DataSource() {
        this.fetchData = __bind(this.fetchData, this);

        this.sourceToCollection = __bind(this.sourceToCollection, this);
        return DataSource.__super__.constructor.apply(this, arguments);
      }

      DataSource.prototype.initialize = function() {
        var dataCollection, params, sourceType;
        if ((!this.has('data')) && (this.has('source'))) {
          sourceType = this.sourceToCollection();
          params = this.attributes['params'] || {};
          dataCollection = new sourceType({
            params: params
          });
          return this.set('data', dataCollection);
        }
      };

      DataSource.prototype.sourceToCollection = function() {
        switch (this.attributes['source']) {
          case 'Galaxy Zoo':
            return GalaxyZooSubjects;
        }
      };

      DataSource.prototype.fetchData = function() {
        return this.attributes['data'].fetch();
      };

      return DataSource;

    })(Backbone.Model);

    module.exports = DataSource;

  }).call(this);
  
}});

window.require.define({"models/galaxy_zoo_subject": function(exports, require, module) {
  (function() {
    var GalaxyZooSubject,
      __hasProp = {}.hasOwnProperty,
      __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

    GalaxyZooSubject = (function(_super) {

      __extends(GalaxyZooSubject, _super);

      function GalaxyZooSubject() {
        return GalaxyZooSubject.__super__.constructor.apply(this, arguments);
      }

      return GalaxyZooSubject;

    })(Backbone.Model);

    module.exports = GalaxyZooSubject;

  }).call(this);
  
}});

