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
      describe('#parse', function() {
        return it('should return a new Tools object as for the tools attribute', function() {
          var dashboard;
          dashboard = new Dashboard;
          dashboard.parse(JSON.stringify(responseJson));
          return expect(dashboard.attributes).to.have.property('tools').and.be.an["instanceof"](Tools);
        });
      });
      describe('#createTool', function() {
        beforeEach(function() {
          this.dashboard = new Dashboard;
          this.toolsSpy = sinon.spy(this.dashboard.get('tools'), 'add');
          return this.dashboard.createTool('table');
        });
        return it('should add a tool to the tools collection', function() {
          return expect(this.toolsSpy).to.have.been.calledWith({
            name: 'new-tool-1',
            type: 'table'
          });
        });
      });
      return describe('#removeTools', function() {
        beforeEach(function() {
          this.dashboard = new Dashboard;
          this.toolsSpy = sinon.spy(this.dashboard.get('tools'), 'reset');
          return this.dashboard.removeTools();
        });
        return it('should call collections rest method', function() {
          return expect(this.toolsSpy).to.have.been.called;
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
      describe('defaults', function() {
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
      describe('#getData', function() {
        return beforeEach(function() {
          return this.tool = new Tool({
            dataSource: new DataSource({
              source: 'Galaxy Zoo'
            })
          });
        });
      });
      return describe('#filterData', function() {
        beforeEach(function() {
          this.filter = new Backbone.Model({
            func: function(x) {
              return console.log(x);
            }
          });
          this.filters = new Filters([this.filter]);
          this.tool = new Tool({
            filters: this.filters,
            dataSource: new DataSource({
              source: 'Galaxy Zoo'
            })
          });
          this.eachSpy = sinon.spy(this.tool.get('filters'), 'each');
          this.filterSpy = sinon.spy(_, 'filter');
          return this.tool.filterData();
        });
        afterEach(function() {
          this.tool.get('filters').each.restore();
          return _.filter.restore();
        });
        it('should call each on filters', function() {
          return expect(this.eachSpy).to.have.been.called;
        });
        return it('should filter data', function() {
          return expect(this.filterSpy).to.have.been.called;
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

window.require.define({"test/views/table_test": function(exports, require, module) {
  (function() {
    var Table;

    Table = require('views/table');

    describe('Table', function() {
      it('should be defined', function() {
        return expect(Table).to.be.ok;
      });
      it('should be instantiable', function() {
        var table;
        table = new Table;
        return expect(table).to.be.ok;
      });
      describe('instatiation', function() {
        beforeEach(function() {
          return this.table = new Table;
        });
        it('should use the table tag', function() {
          return expect(this.table.el.nodeName).to.be('TABLE');
        });
        return it('should have the table-tool class', function() {
          return expect(this.table.$el).to.have["class"]('table-tool');
        });
      });
      describe('#render', function() {
        beforeEach(function() {
          this.tool = new Backbone.Model({
            dataSource: new Backbone.Model({
              data: new Backbone.Collection([
                {
                  id: 1,
                  name: 'test'
                }, {
                  id: 2,
                  name: 'test 2'
                }
              ])
            })
          });
          this.table = new Table({
            model: this.tool,
            id: 'table-1'
          });
          this.templateSpy = sinon.spy(this.table, 'template');
          this.htmlSpy = sinon.spy(this.table.$el, 'html');
          this.ubretSpy = sinon.spy(this.table, 'ubretTable');
          return this.table.render();
        });
        it('should render the table template', function() {
          return expect(this.templateSpy).to.have.been.called;
        });
        it('should append to el', function() {
          return expect(this.htmlSpy).to.have.been.called;
        });
        return it('should create a new Ubret Table', function() {
          return expect(this.ubretSpy).to.have.been.called;
        });
      });
      return describe('#dataKeys', function() {
        return it('should extract all keys from the tool\'s data', function() {
          this.tool = new Backbone.Model({
            dataSource: new Backbone.Model({
              data: new Backbone.Collection([
                {
                  id: 1,
                  name: 'test'
                }, {
                  id: 2,
                  name: 'test 2'
                }
              ])
            })
          });
          this.table = new Table({
            model: this.tool,
            id: 'table-1'
          });
          return expect(this.table.dataKeys()[0]).to.equal('name');
        });
      });
    });

  }).call(this);
  
}});

window.require.define({"test/views/tool_container_test": function(exports, require, module) {
  (function() {
    var ToolContainer;

    ToolContainer = require('views/tool_container');

    describe('ToolContainer', function() {
      it('should be defined', function() {
        return expect(ToolContainer).to.be.ok;
      });
      it('should be instantiable', function() {
        var toolContainer;
        toolContainer = new ToolContainer;
        return expect(toolContainer).to.be.ok;
      });
      describe('instantiation', function() {
        beforeEach(function() {
          return this.toolContainer = new ToolContainer;
        });
        it('should use a div tag', function() {
          return expect(this.toolContainer.el.nodeName).to.equal('DIV');
        });
        return it('should have the tool-container css class', function() {
          return expect(this.toolContainer.$el).to.have["class"]('tool-container');
        });
      });
      describe('#createToolView', function() {
        beforeEach(function() {
          this.tool = new Backbone.Model({
            type: 'table'
          });
          this.requireSpy = sinon.stub(window, 'require').returns(Backbone.View);
          this.container = new ToolContainer({
            model: this.tool
          });
          return this.container.createToolView();
        });
        afterEach(function() {
          return window.require.restore();
        });
        return it('should require the view of the tool based on the model\'s type attribute', function() {
          return expect(this.requireSpy).to.have.been.calledWith('views/table');
        });
      });
      return describe('#render', function() {
        beforeEach(function() {
          this.tool = new Backbone.Model({
            type: 'table'
          });
          this.requireSpy = sinon.stub(window, 'require').returns(Backbone.View);
          this.container = new ToolContainer({
            model: this.tool
          });
          this.renderSpy = sinon.spy(this.container.toolView, 'render');
          this.htmlSpy = sinon.spy(this.container.$el, 'html');
          return this.container.render();
        });
        afterEach(function() {
          return window.require.restore();
        });
        it('should render its toolView', function() {
          return expect(this.renderSpy).to.have.been.called;
        });
        return it('should append the rendered toolView', function() {
          return expect(this.htmlSpy).to.have.been.calledWith(this.container.toolView.el);
        });
      });
    });

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
          this.toolContainer = sinon.stub(this.toolWindow.toolContainer, 'render').returns({
            el: "nuffin"
          });
          this.titleBar = sinon.stub(this.toolWindow.titleBar, 'render').returns({
            el: "nuffin"
          });
          this.toolSettings = sinon.stub(this.toolWindow.settings, 'render').returns({
            el: "nuffin"
          });
          this.append = sinon.stub(this.toolWindow.$el, 'append');
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
        return it('should append everything to el', function() {
          return expect(this.append).to.have.been.calledThrice;
        });
      });
      describe('#setWindowPosition', function() {
        beforeEach(function() {
          var topLeftModel;
          topLeftModel = new Backbone.Model({
            top: 20,
            left: 20,
            name: 'test'
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
            width: 10,
            name: 'test'
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

window.require.define({"test/views/toolbox_test": function(exports, require, module) {
  (function() {
    var Toolbox;

    Toolbox = require('views/toolbox');

    describe('Toolbox', function() {
      it('should be defined', function() {
        return expect(Toolbox).to.be.ok;
      });
      it('should be instantiable', function() {
        var toolbox;
        toolbox = new Toolbox;
        return expect(toolbox).to.be.ok;
      });
      describe('instantiation', function() {
        beforeEach(function() {
          return this.toolbox = new Toolbox;
        });
        it('should use a div tag', function() {
          return expect(this.toolbox.el.nodeName).to.be('DIV');
        });
        return it('should have class name toolbox', function() {
          return expect(this.toolbox.$el).to.have["class"]('toolbox');
        });
      });
      describe('#render', function() {
        beforeEach(function() {
          this.toolbox = new Toolbox;
          this.templateSpy = sinon.spy(this.toolbox, 'template');
          return this.toolbox.render();
        });
        return it('should render template', function() {
          return expect(this.templateSpy).to.have.been.called;
        });
      });
      describe('#createTool', function() {
        beforeEach(function() {
          this.toolbox = new Toolbox;
          this.triggerSpy = sinon.spy(this.toolbox, 'trigger');
          return this.toolbox.render().$el.find('button[name="table"]').click();
        });
        return it('should trigger a create-table event', function() {
          return expect(this.triggerSpy).to.have.been.calledWith('create-table');
        });
      });
      return describe('#createTool', function() {
        beforeEach(function() {
          this.toolbox = new Toolbox;
          this.triggerSpy = sinon.spy(this.toolbox, 'trigger');
          return this.toolbox.render().$el.find('button[name="remove-tools"]').click();
        });
        return it('should trigger a create-table event', function() {
          return expect(this.triggerSpy).to.have.been.calledWith('remove-tools');
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
      describe('instantiation', function() {
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
      describe('#render', function() {
        beforeEach(function() {
          this.model = new Backbone.Model({
            name: 'new-tool'
          });
          this.title = new WindowTitleBar({
            model: this.model
          });
          this.templateSpy = sinon.spy(this.title, 'template');
          this.htmlSpy = sinon.spy(this.title.$el, 'html');
          return this.title.render();
        });
        it('should render the template', function() {
          return expect(this.templateSpy).to.have.been.called;
        });
        it('should append the html ', function() {
          return expect(this.htmlSpy).to.have.been.called;
        });
        return it('should have a title', function() {
          return expect(this.title.$('.window-title')).to.have.text('new-tool');
        });
      });
      describe('#close', function() {
        beforeEach(function() {
          this.title = new WindowTitleBar;
          this.triggerSpy = sinon.spy(this.title, 'trigger');
          return this.title.close();
        });
        return it('should trigger close event', function() {
          return expect(this.triggerSpy).to.have.been.calledWith('close');
        });
      });
      describe('#settings', function() {
        beforeEach(function() {
          this.title = new WindowTitleBar;
          this.triggerSpy = sinon.spy(this.title, 'trigger');
          return this.title.settings();
        });
        return it('should trigger close event', function() {
          return expect(this.triggerSpy).to.have.been.calledWith('settings');
        });
      });
      describe('#startDrag', function() {
        beforeEach(function() {
          this.title = new WindowTitleBar;
          this.triggerSpy = sinon.spy(this.title, 'trigger');
          return this.title.startDrag();
        });
        return it('should trigger close event', function() {
          return expect(this.triggerSpy).to.have.been.calledWith('startDrag');
        });
      });
      describe('#endDrag', function() {
        beforeEach(function() {
          this.title = new WindowTitleBar;
          this.triggerSpy = sinon.spy(this.title, 'trigger');
          return this.title.endDrag();
        });
        return it('should trigger close event', function() {
          return expect(this.triggerSpy).to.have.been.calledWith('endDrag');
        });
      });
      describe('#editTitle', function() {
        beforeEach(function() {
          this.title = new WindowTitleBar;
          return this.title.render().editTitle();
        });
        it('should hide window title', function() {
          return expect(this.title.$('.window-title')).to.be.hidden;
        });
        return it('should show the window title input field', function() {
          return expect(this.title.$('input')).to.be.visible;
        });
      });
      return describe('#updateModel', function() {
        beforeEach(function() {
          this.title = new WindowTitleBar({
            model: new Backbone.Model
          });
          return this.title.render().editTitle();
        });
        describe('when escape is pressed', function() {
          beforeEach(function() {
            var event;
            event = {
              which: 27
            };
            return this.title.updateModel(event);
          });
          it('should show window title', function() {
            return expect(this.title.$('.window-title')).to.be.visible;
          });
          return it('should hide the window title input field', function() {
            return expect(this.title.$('input')).to.be.hidden;
          });
        });
        return describe('when a blur event is triggered or the enter key is pressed', function() {
          beforeEach(function() {
            var event;
            event = {
              type: 'blur',
              which: 13
            };
            this.title.updateModel(event);
            return this.modelSpy = sinon.spy(this.title.model, 'set');
          });
          return it('should get the model\'s name property', function() {
            return expect(this.modelSpy).to.have.been.calledWith('title', '');
          });
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
window.require('test/views/table_test');
window.require('test/views/tool_container_test');
window.require('test/views/tool_window_test');
window.require('test/views/toolbox_test');
window.require('test/views/window_title_bar_test');
