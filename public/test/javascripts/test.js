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

window.require.define({"test/collections/filters_test": function(exports, require, module) {
  (function() {
    var Filter, Filters;

    Filters = require('collections/filters');

    Filter = require('models/filter');

    describe('Filters', function() {
      it('should be defined', function() {
        return expect(Filters).to.be.ok;
      });
      it('should be instantiable', function() {
        var filters;
        filters = new Filters;
        return expect(filters).to.be.ok;
      });
      return describe('properties', function() {
        beforeEach(function() {
          return this.filters = new Filters;
        });
        return it('should have Filter as it\'s model', function() {
          return expect(this.filters).to.have.property('model').and.equal(Filter);
        });
      });
    });

  }).call(this);
  
}});

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

window.require.define({"test/collections/tools_test": function(exports, require, module) {
  (function() {
    var Tool, Tools;

    Tools = require('collections/tools');

    Tool = require('models/tool');

    describe('Tools', function() {
      it('should be defined', function() {
        return expect(Tools).to.be.ok;
      });
      it('should be instantiable', function() {
        var tools;
        tools = new Tools;
        return expect(tools).to.be.ok;
      });
      return describe('properties', function() {
        beforeEach(function() {
          return this.tools = new Tools;
        });
        return it('should use Tool as it\'s model', function() {
          return expect(this.tools).to.have.property('model').and.equal(Tool);
        });
      });
    });

  }).call(this);
  
}});

window.require.define({"test/models/dashboard_test": function(exports, require, module) {
  (function() {
    var Dashboard, Tools;

    Dashboard = require('models/dashboard');

    Tools = require('collections/tools');

    describe('Dashboard', function() {
      var responseJson;
      responseJson = {
        id: 1,
        name: 'My Cool Dashboard',
        tools: new Tools
      };
      it('should be defined', function() {
        return expect(Dashboard).to.be.ok;
      });
      it('should be instantiable', function() {
        var dashboard;
        dashboard = new Dashboard;
        return expect(dashboard).to.be.ok;
      });
      describe('Defaults', function() {
        beforeEach(function() {
          return this.dashboard = new Dashboard;
        });
        return it('should have a collection of tools', function() {
          return expect(this.dashboard.attributes).to.have.property('tools').and.be.an["instanceof"](Tools);
        });
      });
      describe('Properties', function() {
        beforeEach(function() {
          return this.dashboard = new Dashboard;
        });
        return it('should have a urlRoot property', function() {
          return expect(this.dashboard).to.have.property('urlRoot').and.equal('/dashboard');
        });
      });
      return describe('#parse', function() {
        return it('should return a new Tools object as for the tools attribute', function() {
          var dashboard;
          dashboard = new Dashboard;
          dashboard.parse(JSON.stringify(responseJson));
          return expect(dashboard.attributes).to.have.property('tools').and.be.an["instanceof"](Tools);
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

window.require.define({"test/models/filter_test": function(exports, require, module) {
  (function() {
    var Filter;

    Filter = require('models/filter');

    describe('filter', function() {
      it('should be defined', function() {
        return expect(Filter).to.be.ok;
      });
      return it('should be instantiable', function() {
        var filter;
        filter = new Filter;
        return expect(filter).to.be.ok;
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

window.require.define({"test/models/tool_test": function(exports, require, module) {
  (function() {
    var DataSource, Filters, Tool;

    Tool = require('models/tool');

    DataSource = require('models/data_source');

    Filters = require('collections/filters');

    describe('Tool', function() {
      it('should be defined', function() {
        return expect(Tool).to.be.ok;
      });
      it('should be instantiable', function() {
        var tool;
        tool = new Tool;
        return expect(tool).to.be.ok;
      });
      return describe('defaults', function() {
        beforeEach(function() {
          return this.tool = new Tool;
        });
        it('should have a height of 640', function() {
          return expect(this.tool.get('height')).to.equal(480);
        });
        it('should have a width of 480', function() {
          return expect(this.tool.get('width')).to.equal(640);
        });
        it('should have a new DataSource', function() {
          return expect(this.tool.get('dataSource')).to.be.an["instanceof"](DataSource);
        });
        it('should have a new Filters collection', function() {
          return expect(this.tool.get('filters')).to.be.an["instanceof"](Filters);
        });
        it('should have a top of 20', function() {
          return expect(this.tool.get('top')).to.equal(20);
        });
        it('should have a left of 20', function() {
          return expect(this.tool.get('left')).to.equal(20);
        });
        return it('should have a z-index of 1', function() {
          return expect(this.tool.get('z-index')).to.equal(1);
        });
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

window.require.define({"test/views/dashboard_test": function(exports, require, module) {
  (function() {
    var DashboardView;

    DashboardView = require('views/dashboard');

    describe('Dashboard', function() {
      it('should be defined', function() {
        return expect(DashboardView).to.be.ok;
      });
      it('should be instanitable', function() {
        var dashboard;
        dashboard = new DashboardView;
        return expect(dashboard).to.be.ok;
      });
      describe('instantiation', function() {
        beforeEach(function() {
          return this.dashboard = new DashboardView;
        });
        it('should create a div', function() {
          return expect(this.dashboard.el.nodeName).to.equal('DIV');
        });
        return it('should have class dashboard', function() {
          return expect(this.dashboard.$el).to.have["class"]('dashboard');
        });
      });
      return describe('#render', function() {
        beforeEach(function() {
          this.dashboard = new DashboardView;
          this.dashboardAppend = sinon.spy(this.dashboard.$el, 'append');
          this.toolWindowView = new Backbone.View();
          this.toolRender = sinon.spy(this.toolWindowView, 'render');
          this.toolWindowStub = sinon.stub().returns(this.toolWindowView);
          this.dashboard._setToolWindow(this.toolWindowStub);
          this.tool1 = new Backbone.Model({
            id: 1
          });
          this.tool2 = new Backbone.Model({
            id: 2
          });
          this.tool3 = new Backbone.Model({
            id: 3
          });
          this.dashboard.model = new Backbone.Model({
            id: 1,
            name: "New Dashboard",
            tools: new Backbone.Collection([this.tool1, this.tool2, this.tool3])
          });
          return this.dashboard.render();
        });
        it('should create a tool window for each tool in tools collection', function() {
          expect(this.toolWindowStub).to.have.been.calledThrice;
          expect(this.toolWindowStub).to.have.been.calledWith({
            model: this.tool1
          });
          expect(this.toolWindowStub).to.have.been.calledWith({
            model: this.tool2
          });
          return expect(this.toolWindowStub).to.have.been.calledWith({
            model: this.tool3
          });
        });
        return it('should render the new windows', function() {
          return expect(this.toolRender).to.have.been.calledThrice;
        });
      });
    });

  }).call(this);
  
}});

window.require.define({"test/views/tool_container_test": function(exports, require, module) {
  (function() {
    var ToolContainer;

    ToolContainer = require('views/tool_container');

    describe('ToolContainer', function() {});

  }).call(this);
  
}});

window.require.define({"test/views/tool_window_test": function(exports, require, module) {
  (function() {
    var Settings, ToolContainer, ToolWindow, WindowTitleBar;

    ToolWindow = require('views/tool_window');

    Settings = require('views/settings');

    ToolContainer = require('views/tool_container');

    WindowTitleBar = require('views/window_title_bar');

    describe('ToolWindow', function() {
      it('should be defined', function() {
        return expect(ToolWindow).to.be.ok;
      });
      it('should be instantiable', function() {
        var toolWindow;
        toolWindow = new ToolWindow;
        return expect(toolWindow).to.be.ok;
      });
      describe('instantiation', function() {
        beforeEach(function() {
          return this.toolWindow = new ToolWindow;
        });
        it('should have a div tag', function() {
          return expect(this.toolWindow.el.nodeName).to.equal('DIV');
        });
        it('should have a tool-window class', function() {
          return expect(this.toolWindow.$el).to.have["class"]('tool-window');
        });
        return describe('#initialize', function() {
          it('should create a window title bar', function() {
            return expect(this.toolWindow).to.have.property('titleBar').and.to.be.an["instanceof"](WindowTitleBar);
          });
          it('should create a tool container', function() {
            return expect(this.toolWindow).to.have.property('toolContainer').and.to.be.an["instanceof"](ToolContainer);
          });
          return it('should create a settings container', function() {
            return expect(this.toolWindow).to.have.property('settings').and.to.be.an["instanceof"](Settings);
          });
        });
      });
      describe('#render', function() {
        beforeEach(function() {
          this.toolWindow = new ToolWindow;
          this.toolContainer = sinon.spy(this.toolWindow.toolContainer, 'render');
          this.titleBar = sinon.spy(this.toolWindow.titleBar, 'render');
          this.toolSettings = sinon.spy(this.toolWindow.settings, 'render');
          this.append = sinon.spy(this.toolWindow.$el, 'append');
          return this.toolWindow.render();
        });
        it('should render the title bar', function() {
          return expect(this.titleBar).to.have.been.called;
        });
        it('should render the tool container', function() {
          return expect(this.toolContainer).to.have.been.called;
        });
        it('should render the tool settings', function() {
          return expect(this.toolSettings).to.have.been.called;
        });
        return it('should append everything to to el', function() {
          return expect(this.append).to.have.been.calledThrice;
        });
      });
      describe('#setWindowPosition', function() {
        beforeEach(function() {
          var topLeftModel;
          topLeftModel = new Backbone.Model({
            top: 20,
            left: 20
          });
          return this.toolWindow = new ToolWindow({
            model: topLeftModel
          });
        });
        it('should set the left css property to the model\'s left value', function() {
          return expect(this.toolWindow.$el).to.have.css('left').be(20);
        });
        return it('should set the top css property to the model\'s top value', function() {
          return expect(this.toolWindow.$el).to.have.css('top').be(20);
        });
      });
      describe('#setWindowSize', function() {
        beforeEach(function() {
          var heightWidthModel;
          heightWidthModel = new Backbone.Model({
            height: 10,
            width: 10
          });
          return this.toolWindow = new ToolWindow({
            model: heightWidthModel
          });
        });
        it('should set css height to the model\'s height', function() {
          return expect(this.toolWindow.$el).to.have.css('height').be(10);
        });
        return it('should set css width to the model\'s width', function() {
          return expect(this.toolWindow.$el).to.have.css('width').be(10);
        });
      });
      describe('#toggleSettings', function() {
        return it('should toggle the settings-active class', function() {
          var toggle, toolWindow;
          toolWindow = new ToolWindow;
          toggle = sinon.spy(toolWindow.$el, 'toggleClass');
          toolWindow.toggleSettings();
          return expect(toggle).to.have.been.calledWith('settings-active');
        });
      });
      return describe('#close', function() {
        beforeEach(function() {
          this.toolWindow = new ToolWindow({
            model: new Backbone.Model({
              stuff: 1,
              stuff: 2
            })
          });
          this.modelSpy = sinon.spy(this.toolWindow.model, 'destroy');
          this.viewSpy = sinon.spy(this.toolWindow, 'remove');
          return this.toolWindow.close();
        });
        it('should destroy the model', function() {
          return expect(this.modelSpy).to.have.been.called;
        });
        return it('should remove the view', function() {
          return expect(this.viewSpy).to.have.been.called;
        });
      });
    });

  }).call(this);
  
}});

window.require.define({"test/views/window_title_bar_test": function(exports, require, module) {
  (function() {
    var WindowTitleBar;

    WindowTitleBar = require('views/window_title_bar');

    describe('WindowTitleBar', function() {
      it('should be defined', function() {
        return expect(WindowTitleBar).to.be.ok;
      });
      it('should instantiable', function() {
        var titleBar;
        titleBar = new WindowTitleBar;
        return expect(titleBar).to.be.ok;
      });
      return describe('instantiation', function() {
        beforeEach(function() {
          return this.titleBar = new WindowTitleBar;
        });
        it('should use a div tag', function() {
          return expect(this.titleBar.el.nodeName).to.equal('DIV');
        });
        return it('should have the title-bar css class', function() {
          return expect(this.titleBar.$el).to.have["class"]('title-bar');
        });
      });
    });

  }).call(this);
  
}});

window.require('test/collections/filters_test');
window.require('test/collections/galaxy_zoo_subjects_test');
window.require('test/collections/tools_test');
window.require('test/models/dashboard_test');
window.require('test/models/data_source_test');
window.require('test/models/filter_test');
window.require('test/models/galaxy_zoo_subject_test');
window.require('test/models/tool_test');
window.require('test/views/dashboard_test');
window.require('test/views/tool_container_test');
window.require('test/views/tool_window_test');
window.require('test/views/window_title_bar_test');
