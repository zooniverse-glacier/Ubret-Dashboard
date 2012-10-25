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

window.require.define({"test/collections/galaxy_zoo_subjects_test": function(exports, require, module) {
  (function() {
    var GalaxyZooSubject, GalaxyZooSubjects;

    GalaxyZooSubjects = require('collections/galaxy_zoo_subjects');

    GalaxyZooSubject = require('models/galaxy_zoo_subject');

    describe('GalaxyZooSubjects', function() {
      it('should be defined', function() {
        return expect(GalaxyZooSubjects).to.be.ok;
      });
      it('should be instantiable', function() {
        var gzSubjects;
        gzSubjects = new GalaxyZooSubjects;
        return expect(gzSubjects).to.be.ok;
      });
      describe('properties', function() {
        beforeEach(function() {
          return this.gzSubject = new GalaxyZooSubjects;
        });
        it('should have GalaxyZooSubject defined as its model', function() {
          return expect(this.gzSubject).to.have.property('model').and.equal(GalaxyZooSubject);
        });
        return it('should have a defualt set of params defined', function() {
          return expect(this.gzSubject).to.have.property('params').and.to.have.property('limit', 10);
        });
      });
      describe('#url', function() {
        return it('should return url of the form /gz_subjects?(params)', function() {
          var gzSubject;
          gzSubject = new GalaxyZooSubjects;
          return expect(gzSubject.url()).to.equal("/gz_subjects?limit=10");
        });
      });
      return describe('#processParams', function() {
        return it('should convert hash to a string of the form param=setting', function() {
          var gzSubject;
          gzSubject = new GalaxyZooSubjects;
          return expect(gzSubject.processParams()).to.equal('limit=10');
        });
      });
    });

  }).call(this);
  
}});

window.require.define({"test/models/data_source_test": function(exports, require, module) {
  (function() {
    var DataSource, GalaxyZooSubjects;

    DataSource = require('models/data_source');

    GalaxyZooSubjects = require('collections/galaxy_zoo_subjects');

    describe('DataSource', function() {
      it('should be defined', function() {
        return expect(DataSource).to.be.ok;
      });
      it('should be instantiable', function() {
        var dataSource;
        dataSource = new DataSource;
        return expect(dataSource).to.be.ok;
      });
      describe('attributes', function() {
        return it('should have a data attribute that based on the data source', function() {
          var dataSource;
          dataSource = new DataSource({
            source: 'Galaxy Zoo'
          });
          sinon.spy(dataSource.get('data'), 'fetch');
          return expect(dataSource.get('data')).to.be.an["instanceof"](GalaxyZooSubjects);
        });
      });
      describe('#sourceToCollection', function() {
        return it('should convert the string name of the source into the class name of the collection', function() {
          var dataSource;
          dataSource = new DataSource({
            source: 'Galaxy Zoo'
          });
          sinon.spy(dataSource.get('data'), 'fetch');
          return expect(dataSource.sourceToCollection()).to.equal(GalaxyZooSubjects);
        });
      });
      return describe('#fetchData', function() {
        return it('should call the data collection\'s fetch method', function() {
          var dataSource, fetchSpy;
          dataSource = new DataSource({
            source: 'Galaxy Zoo'
          });
          fetchSpy = sinon.spy(dataSource.get('data'), 'fetch');
          dataSource.fetchData();
          return expect(fetchSpy).to.have.been.called;
        });
      });
    });

  }).call(this);
  
}});

window.require.define({"test/models/galaxy_zoo_subject_test": function(exports, require, module) {
  (function() {
    var GalaxyZooSubject;

    GalaxyZooSubject = require('models/galaxy_zoo_subject');

    describe('GalaxyZooSubject', function() {
      it('should be defined', function() {
        return expect(GalaxyZooSubject).to.be.ok;
      });
      return it('should be instantiable', function() {
        var galaxyZooSubject;
        galaxyZooSubject = new GalaxyZooSubject;
        return expect(galaxyZooSubject).to.be.ok;
      });
    });

  }).call(this);
  
}});

window.require.define({"test/test-helpers": function(exports, require, module) {
  (function() {
    var chai, sinonChai;

    chai = require('chai');

    sinonChai = require('sinon-chai');

    chai.use(sinonChai);

    module.exports = {
      expect: chai.expect,
      sinon: require('sinon')
    };

  }).call(this);
  
}});

window.require('test/collections/galaxy_zoo_subjects_test');
window.require('test/models/data_source_test');
window.require('test/models/galaxy_zoo_subject_test');
