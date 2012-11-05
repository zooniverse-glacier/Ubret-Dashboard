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
    var Router, application;

    Router = require('router');

    application = {
      initialize: function() {
        var router;
        router = new Router;
        return Backbone.history.start();
      }
    };

    module.exports = application;

  }).call(this);
  
}});

window.require.define({"collections/filters": function(exports, require, module) {
  (function() {
    var Filter, Filters,
      __hasProp = {}.hasOwnProperty,
      __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

    Filter = require('models/filter');

    Filters = (function(_super) {

      __extends(Filters, _super);

      function Filters() {
        return Filters.__super__.constructor.apply(this, arguments);
      }

      Filters.prototype.model = Filter;

      return Filters;

    })(Backbone.Collection);

    module.exports = Filters;

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

window.require.define({"collections/tools": function(exports, require, module) {
  (function() {
    var Tool, Tools,
      __hasProp = {}.hasOwnProperty,
      __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

    Tool = require('models/tool');

    Tools = (function(_super) {

      __extends(Tools, _super);

      function Tools() {
        return Tools.__super__.constructor.apply(this, arguments);
      }

      Tools.prototype.model = Tool;

      return Tools;

    })(Backbone.Collection);

    module.exports = Tools;

  }).call(this);
  
}});

window.require.define({"initialize": function(exports, require, module) {
  (function() {
    var application;

    application = require('application');

    $(document).on('ready', function() {
      return application.initialize();
    });

  }).call(this);
  
}});

window.require.define({"models/dashboard": function(exports, require, module) {
  (function() {
    var Dashboard, Tools,
      __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
      __hasProp = {}.hasOwnProperty,
      __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

    Tools = require('collections/tools');

    Dashboard = (function(_super) {

      __extends(Dashboard, _super);

      function Dashboard() {
        this.removeTools = __bind(this.removeTools, this);

        this.createTool = __bind(this.createTool, this);
        return Dashboard.__super__.constructor.apply(this, arguments);
      }

      Dashboard.prototype.defaults = {
        "tools": new Tools
      };

      Dashboard.prototype.urlRoot = '/dashboard';

      Dashboard.prototype.initialize = function() {
        return this.count = this.get('tools').length + 1;
      };

      Dashboard.prototype.parse = function(response) {
        response.tools = new Tools(response.tools);
        return response;
      };

      Dashboard.prototype.createTool = function(toolType) {
        this.get('tools').add({
          type: toolType,
          name: "new-tool-" + this.count
        });
        return this.count += 1;
      };

      Dashboard.prototype.removeTools = function() {
        return this.get('tools').reset();
      };

      return Dashboard;

    })(Backbone.Model);

    module.exports = Dashboard;

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
        this.isExternal = __bind(this.isExternal, this);

        this.createNewData = __bind(this.createNewData, this);

        this.fetchData = __bind(this.fetchData, this);

        this.sourceToCollection = __bind(this.sourceToCollection, this);
        return DataSource.__super__.constructor.apply(this, arguments);
      }

      DataSource.prototype.initialize = function() {
        this.on('change:source', this.createNewData);
        if ((!this.has('data')) && (this.has('source'))) return this.createNewData();
      };

      DataSource.prototype.sourceToCollection = function() {
        switch (this.attributes['source']) {
          case 'Galaxy Zoo':
            return GalaxyZooSubjects;
          default:
            return 'internal';
        }
      };

      DataSource.prototype.fetchData = function() {
        return this.attributes['data'].fetch();
      };

      DataSource.prototype.createNewData = function() {
        var dataCollection, params, sourceType;
        sourceType = this.sourceToCollection();
        if (sourceType !== 'internal') {
          params = this.attributes['params'] || {};
          dataCollection = new sourceType([], {
            params: params
          });
          console.log(dataCollection);
          return this.set('data', dataCollection);
        }
      };

      DataSource.prototype.isExternal = function() {
        return this.sourceToCollection() !== 'internal';
      };

      return DataSource;

    })(Backbone.Model);

    module.exports = DataSource;

  }).call(this);
  
}});

window.require.define({"models/filter": function(exports, require, module) {
  (function() {
    var Filter,
      __hasProp = {}.hasOwnProperty,
      __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

    Filter = (function(_super) {

      __extends(Filter, _super);

      function Filter() {
        return Filter.__super__.constructor.apply(this, arguments);
      }

      return Filter;

    })(Backbone.Model);

    module.exports = Filter;

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

window.require.define({"models/tool": function(exports, require, module) {
  (function() {
    var DataSource, Filters, Tool,
      __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
      __hasProp = {}.hasOwnProperty,
      __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

    DataSource = require('models/data_source');

    Filters = require('collections/filters');

    Tool = (function(_super) {

      __extends(Tool, _super);

      function Tool() {
        this.getData = __bind(this.getData, this);

        this.filterData = __bind(this.filterData, this);
        return Tool.__super__.constructor.apply(this, arguments);
      }

      Tool.prototype.defaults = {
        "dataSource": new DataSource,
        "filters": new Filters,
        "height": 480,
        "width": 640,
        "left": 20,
        "top": 20,
        "z-index": 1
      };

      Tool.prototype.filterData = function() {
        var filteredData,
          _this = this;
        filteredData = this.get('dataSource').get('data').models;
        this.get('filters').each(function(filter) {
          return filteredData = _.filter(filteredData, filter.get('func'));
        });
        return filteredData;
      };

      Tool.prototype.getData = function() {
        if (!this.get('dataSource').has('source')) return [];
        return this.filterData();
      };

      return Tool;

    })(Backbone.Model);

    module.exports = Tool;

  }).call(this);
  
}});

window.require.define({"router": function(exports, require, module) {
  (function() {
    var DashboardModel, DashboardView, Router, Toolbox,
      __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
      __hasProp = {}.hasOwnProperty,
      __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

    DashboardModel = require('models/dashboard');

    DashboardView = require('views/dashboard');

    Toolbox = require('views/toolbox');

    Router = (function(_super) {

      __extends(Router, _super);

      function Router() {
        this.dropTools = __bind(this.dropTools, this);

        this.addTable = __bind(this.addTable, this);

        this.toolboxEvents = __bind(this.toolboxEvents, this);

        this.retrieveDashbaord = __bind(this.retrieveDashbaord, this);

        this.index = __bind(this.index, this);
        return Router.__super__.constructor.apply(this, arguments);
      }

      Router.prototype.routes = {
        '': 'index',
        'dashboard/:id': 'retrieveDashboard'
      };

      Router.prototype.index = function() {
        this.dashboardModel = new DashboardModel;
        this.dashboard = new DashboardView({
          model: this.dashboardModel,
          el: '.dashboard'
        });
        if (this.toolbox == null) {
          this.toolbox = new Toolbox({
            el: '.toolbox'
          });
        }
        this.dashboard.render();
        this.toolbox.render();
        return this.toolboxEvents();
      };

      Router.prototype.retrieveDashbaord = function(id) {
        this.dashboardModel = new DashboardModel({
          id: id
        });
        this.dashboardModel.fetch();
        this.dashboard = new DashboardView({
          model: this.dashboardModel,
          el: '.dashboard'
        });
        if (this.toolbox == null) {
          this.toolbox = new Toolbox({
            el: '.toolbox'
          });
        }
        this.dashboard.render();
        this.toolbox.render();
        return this.toolboxEvents();
      };

      Router.prototype.toolboxEvents = function() {
        this.toolbox.on('create-table', this.addTable);
        return this.toolbox.on('remove-tools', this.dropTools);
      };

      Router.prototype.addTable = function() {
        return this.dashboardModel.createTool('table');
      };

      Router.prototype.dropTools = function() {
        return this.dashboardModel.dropTools();
      };

      return Router;

    })(Backbone.Router);

    module.exports = Router;

  }).call(this);
  
}});

window.require.define({"views/dashboard": function(exports, require, module) {
  (function() {
    var DashboardView, ToolWindow,
      __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
      __hasProp = {}.hasOwnProperty,
      __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

    ToolWindow = require('views/tool_window');

    DashboardView = (function(_super) {

      __extends(DashboardView, _super);

      function DashboardView() {
        this.addTool = __bind(this.addTool, this);

        this.createToolWindow = __bind(this.createToolWindow, this);

        this.render = __bind(this.render, this);
        return DashboardView.__super__.constructor.apply(this, arguments);
      }

      DashboardView.prototype.tagName = 'div';

      DashboardView.prototype.className = 'dashboard';

      DashboardView.prototype.initialize = function() {
        var _ref;
        return (_ref = this.model) != null ? _ref.get('tools').on('add', this.addTool) : void 0;
      };

      DashboardView.prototype.render = function() {
        this.model.get('tools').each(this.createToolWindow);
        return this;
      };

      DashboardView.prototype.createToolWindow = function(tool) {
        var toolWindow;
        toolWindow = new ToolWindow({
          model: tool
        });
        return this.$el.append(toolWindow.render().el);
      };

      DashboardView.prototype.addTool = function() {
        return this.createToolWindow(this.model.get('tools').last());
      };

      DashboardView.prototype._setToolWindow = function(toolWindow) {
        return ToolWindow = toolWindow;
      };

      return DashboardView;

    })(Backbone.View);

    module.exports = DashboardView;

  }).call(this);
  
}});

window.require.define({"views/data_settings": function(exports, require, module) {
  (function() {
    var DataSettings,
      __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
      __hasProp = {}.hasOwnProperty,
      __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

    DataSettings = (function(_super) {

      __extends(DataSettings, _super);

      function DataSettings() {
        this.setSource = __bind(this.setSource, this);

        this.updateModel = __bind(this.updateModel, this);

        this.showInternal = __bind(this.showInternal, this);

        this.showExternal = __bind(this.showExternal, this);

        this.render = __bind(this.render, this);
        return DataSettings.__super__.constructor.apply(this, arguments);
      }

      DataSettings.prototype.tagName = 'div';

      DataSettings.prototype.className = 'data-settings';

      DataSettings.prototype.template = require('./templates/data_settings');

      DataSettings.prototype.extSources = {
        'Galaxy Zoo': 'Galaxy Zoo Subjects'
      };

      DataSettings.prototype.events = {
        'click .type-select a.external': 'showExternal',
        'click .type-select a.internal': 'showInternal',
        'click button[name="fetch"]': 'updateModel'
      };

      DataSettings.prototype.initialize = function() {
        var _ref, _ref1;
        if ((_ref = this.model) != null) _ref.on('change:source', this.setSource);
        return (_ref1 = this.model) != null ? _ref1.on('change:params', this.setParams) : void 0;
      };

      DataSettings.prototype.render = function() {
        var extSources, intSources;
        extSources = this.extSources;
        intSources = this.intSources || [];
        this.$el.html(this.template({
          extSources: extSources,
          intSources: intSources
        }));
        return this;
      };

      DataSettings.prototype.showExternal = function() {
        this.$('.internal-settings').hide();
        this.$('.external-settings').show();
        this.$('button[name="fetch"]').show();
        return this.external = true;
      };

      DataSettings.prototype.showInternal = function() {
        this.$('.internal-settings').show();
        this.$('.external-settings').hide();
        this.$('button[name="fetch"]').show();
        return this.external = false;
      };

      DataSettings.prototype.updateModel = function() {
        var params, source;
        if (this.external) {
          source = this.$('select.external-sources').val();
          params = new Object;
          this.$('.external-settings input').each(function(index) {
            var name, value;
            name = $(this).attr('name');
            value = $(this).val();
            return params[name] = value;
          });
          this.model.set('params', params);
          this.model.set('source', source);
        } else {
          source = this.$('select.internal-sources').val();
          this.model.set('source', source);
        }
        return this.model.fetchData();
      };

      DataSettings.prototype.setSource = function() {
        var source;
        source = this.model.get('source');
        if (this.model.isExternal) return console.log('here');
      };

      return DataSettings;

    })(Backbone.View);

    module.exports = DataSettings;

  }).call(this);
  
}});

window.require.define({"views/settings": function(exports, require, module) {
  (function() {
    var DataSettings, Settings,
      __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
      __hasProp = {}.hasOwnProperty,
      __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

    DataSettings = require('views/data_settings');

    Settings = (function(_super) {

      __extends(Settings, _super);

      function Settings() {
        this.render = __bind(this.render, this);
        return Settings.__super__.constructor.apply(this, arguments);
      }

      Settings.prototype.tagName = 'div';

      Settings.prototype.className = 'settings';

      Settings.prototype.initialize = function() {
        if (this.model != null) {
          return this.dataSettings = new DataSettings({
            model: this.model.get('dataSource')
          });
        }
      };

      Settings.prototype.render = function() {
        var _this = this;
        _.each([this.dataSettings], function(subSetting) {
          return _this.$el.append(subSetting.render().el);
        });
        return this;
      };

      return Settings;

    })(Backbone.View);

    module.exports = Settings;

  }).call(this);
  
}});

window.require.define({"views/table": function(exports, require, module) {
  (function() {
    var Table,
      __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
      __hasProp = {}.hasOwnProperty,
      __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
      __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

    Table = (function(_super) {

      __extends(Table, _super);

      function Table() {
        this.dataKeys = __bind(this.dataKeys, this);

        this.render = __bind(this.render, this);
        return Table.__super__.constructor.apply(this, arguments);
      }

      Table.prototype.template = require('./templates/table');

      Table.prototype.noDataTemplate = require('./templates/no_data');

      Table.prototype.tagName = 'table';

      Table.prototype.className = 'table-tool';

      Table.prototype.ubretTable = Ubret.Table;

      Table.prototype.nonDisplayKeys = ['id'];

      Table.prototype.initialize = function() {
        var _ref,
          _this = this;
        return (_ref = this.model) != null ? _ref.get('dataSource').on('change:source', function() {
          return _this.model.get('dataSource').get('data').on('reset', _this.render);
        }) : void 0;
      };

      Table.prototype.render = function() {
        var data, formattedData;
        data = this.model.getData();
        if (data.length === 0) {
          this.$el.html(this.noDataTemplate());
        } else {
          this.$el.html(this.template());
          formattedData = _.map(data, function(datum) {
            return datum.toJSON();
          });
          this.table = new this.ubretTable(this.dataKeys(data), formattedData, "table#" + this.id);
        }
        return this;
      };

      Table.prototype.dataKeys = function(data) {
        var dataModel, key, keys, value;
        dataModel = data[0].toJSON();
        keys = new Array;
        for (key in dataModel) {
          value = dataModel[key];
          if (__indexOf.call(this.nonDisplayKeys, key) < 0) keys.push(key);
        }
        return keys;
      };

      return Table;

    })(Backbone.View);

    module.exports = Table;

  }).call(this);
  
}});

window.require.define({"views/templates/data_settings": function(exports, require, module) {
  module.exports = function (__obj) {
    if (!__obj) __obj = {};
    var __out = [], __capture = function(callback) {
      var out = __out, result;
      __out = [];
      callback.call(this);
      result = __out.join('');
      __out = out;
      return __safe(result);
    }, __sanitize = function(value) {
      if (value && value.ecoSafe) {
        return value;
      } else if (typeof value !== 'undefined' && value != null) {
        return __escape(value);
      } else {
        return '';
      }
    }, __safe, __objSafe = __obj.safe, __escape = __obj.escape;
    __safe = __obj.safe = function(value) {
      if (value && value.ecoSafe) {
        return value;
      } else {
        if (!(typeof value !== 'undefined' && value != null)) value = '';
        var result = new String(value);
        result.ecoSafe = true;
        return result;
      }
    };
    if (!__escape) {
      __escape = __obj.escape = function(value) {
        return ('' + value)
          .replace(/&/g, '&amp;')
          .replace(/</g, '&lt;')
          .replace(/>/g, '&gt;')
          .replace(/"/g, '&quot;');
      };
    }
    (function() {
      (function() {
        var key, source, value, _i, _len, _ref, _ref1;
      
        __out.push('<h3>Data Source</h3>\n\n<ul class="type-select">\n  <li><a class="external">External API</a></li>\n  <li><a class="internal">Other Tool</a></li>\n</ul>\n\n<div class="external-settings">\n  <select class="external-sources">\n      <option value="">Select External API</option>\n    ');
      
        _ref = this.extSources;
        for (key in _ref) {
          value = _ref[key];
          __out.push('\n      <option value="');
          __out.push(key);
          __out.push('">');
          __out.push(value);
          __out.push('</option>\n    ');
        }
      
        __out.push('\n  </select>\n\n  <label>Number: <input type="text" name="limit" placeholder="No. of Objects to fetch" /></label>\n</div>\n\n<div class="internal-settings">\n  <select class="internal-sources">\n      <option value="">Select Tool</option>\n    ');
      
        _ref1 = this.intSources;
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          source = _ref1[_i];
          __out.push('\n      <option value="');
          __out.push(source);
          __out.push('">');
          __out.push(source);
          __out.push('</option>\n    ');
        }
      
        __out.push('\n  </select>\n</div>\n\n<button type="button" name="fetch">Fetch Data</button>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  }
}});

window.require.define({"views/templates/no_data": function(exports, require, module) {
  module.exports = function (__obj) {
    if (!__obj) __obj = {};
    var __out = [], __capture = function(callback) {
      var out = __out, result;
      __out = [];
      callback.call(this);
      result = __out.join('');
      __out = out;
      return __safe(result);
    }, __sanitize = function(value) {
      if (value && value.ecoSafe) {
        return value;
      } else if (typeof value !== 'undefined' && value != null) {
        return __escape(value);
      } else {
        return '';
      }
    }, __safe, __objSafe = __obj.safe, __escape = __obj.escape;
    __safe = __obj.safe = function(value) {
      if (value && value.ecoSafe) {
        return value;
      } else {
        if (!(typeof value !== 'undefined' && value != null)) value = '';
        var result = new String(value);
        result.ecoSafe = true;
        return result;
      }
    };
    if (!__escape) {
      __escape = __obj.escape = function(value) {
        return ('' + value)
          .replace(/&/g, '&amp;')
          .replace(/</g, '&lt;')
          .replace(/>/g, '&gt;')
          .replace(/"/g, '&quot;');
      };
    }
    (function() {
      (function() {
      
        __out.push('<h2>No Data, Please Connect a Data Source</h2>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  }
}});

window.require.define({"views/templates/table": function(exports, require, module) {
  module.exports = function (__obj) {
    if (!__obj) __obj = {};
    var __out = [], __capture = function(callback) {
      var out = __out, result;
      __out = [];
      callback.call(this);
      result = __out.join('');
      __out = out;
      return __safe(result);
    }, __sanitize = function(value) {
      if (value && value.ecoSafe) {
        return value;
      } else if (typeof value !== 'undefined' && value != null) {
        return __escape(value);
      } else {
        return '';
      }
    }, __safe, __objSafe = __obj.safe, __escape = __obj.escape;
    __safe = __obj.safe = function(value) {
      if (value && value.ecoSafe) {
        return value;
      } else {
        if (!(typeof value !== 'undefined' && value != null)) value = '';
        var result = new String(value);
        result.ecoSafe = true;
        return result;
      }
    };
    if (!__escape) {
      __escape = __obj.escape = function(value) {
        return ('' + value)
          .replace(/&/g, '&amp;')
          .replace(/</g, '&lt;')
          .replace(/>/g, '&gt;')
          .replace(/"/g, '&quot;');
      };
    }
    (function() {
      (function() {
      
        __out.push('<thead></thead>\n<tbody></tbody>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  }
}});

window.require.define({"views/templates/toolbox": function(exports, require, module) {
  module.exports = function (__obj) {
    if (!__obj) __obj = {};
    var __out = [], __capture = function(callback) {
      var out = __out, result;
      __out = [];
      callback.call(this);
      result = __out.join('');
      __out = out;
      return __safe(result);
    }, __sanitize = function(value) {
      if (value && value.ecoSafe) {
        return value;
      } else if (typeof value !== 'undefined' && value != null) {
        return __escape(value);
      } else {
        return '';
      }
    }, __safe, __objSafe = __obj.safe, __escape = __obj.escape;
    __safe = __obj.safe = function(value) {
      if (value && value.ecoSafe) {
        return value;
      } else {
        if (!(typeof value !== 'undefined' && value != null)) value = '';
        var result = new String(value);
        result.ecoSafe = true;
        return result;
      }
    };
    if (!__escape) {
      __escape = __obj.escape = function(value) {
        return ('' + value)
          .replace(/&/g, '&amp;')
          .replace(/</g, '&lt;')
          .replace(/>/g, '&gt;')
          .replace(/"/g, '&quot;');
      };
    }
    (function() {
      (function() {
        var tool, _i, _len, _ref;
      
        _ref = this.tools;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          tool = _ref[_i];
          __out.push('\n  <div class="tool-icon" data-id="');
          __out.push(tool.name.toLowerCase());
          __out.push('">\n    <button type="button" name="');
          __out.push(tool.name.toLowerCase());
          __out.push('">');
          __out.push(tool.name);
          __out.push('</button>\n  </div>\n');
        }
      
        __out.push('\n\n<div class="remove-tools">\n  <button type="button" name="remove-tools">Clear Tools</button>\n</div>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  }
}});

window.require.define({"views/templates/window_title_bar": function(exports, require, module) {
  module.exports = function (__obj) {
    if (!__obj) __obj = {};
    var __out = [], __capture = function(callback) {
      var out = __out, result;
      __out = [];
      callback.call(this);
      result = __out.join('');
      __out = out;
      return __safe(result);
    }, __sanitize = function(value) {
      if (value && value.ecoSafe) {
        return value;
      } else if (typeof value !== 'undefined' && value != null) {
        return __escape(value);
      } else {
        return '';
      }
    }, __safe, __objSafe = __obj.safe, __escape = __obj.escape;
    __safe = __obj.safe = function(value) {
      if (value && value.ecoSafe) {
        return value;
      } else {
        if (!(typeof value !== 'undefined' && value != null)) value = '';
        var result = new String(value);
        result.ecoSafe = true;
        return result;
      }
    };
    if (!__escape) {
      __escape = __obj.escape = function(value) {
        return ('' + value)
          .replace(/&/g, '&amp;')
          .replace(/</g, '&lt;')
          .replace(/>/g, '&gt;')
          .replace(/"/g, '&quot;');
      };
    }
    (function() {
      (function() {
      
        __out.push('<span class=\'window-close\'>X</span>\n<span class=\'open-settings\'>S</span>\n<span class=\'window-title\'>');
      
        __out.push(this.name);
      
        __out.push('</span>\n<input type="text" name="window-title" value="');
      
        __out.push(this.name);
      
        __out.push('" />\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  }
}});

window.require.define({"views/tool_container": function(exports, require, module) {
  (function() {
    var ToolContainer,
      __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
      __hasProp = {}.hasOwnProperty,
      __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

    ToolContainer = (function(_super) {

      __extends(ToolContainer, _super);

      function ToolContainer() {
        this.render = __bind(this.render, this);

        this.updateTool = __bind(this.updateTool, this);

        this.createToolView = __bind(this.createToolView, this);

        this.initialize = __bind(this.initialize, this);
        return ToolContainer.__super__.constructor.apply(this, arguments);
      }

      ToolContainer.prototype.tagName = 'div';

      ToolContainer.prototype.className = 'tool-container';

      ToolContainer.prototype.toolTypes = {
        'table': 'views/table'
      };

      ToolContainer.prototype.initialize = function() {
        if (this.model != null) {
          this.createToolView();
          return this.model.on('change', this.updateTool());
        }
      };

      ToolContainer.prototype.createToolView = function() {
        var tool, toolName;
        toolName = this.model.get('type');
        if (toolName != null) {
          tool = require(this.toolTypes[toolName]);
          return this.toolView = new tool({
            model: this.model,
            id: this.model.get('name')
          });
        }
      };

      ToolContainer.prototype.updateTool = function() {
        if (this.model.hasChanged('type')) {
          this.toolView.remove();
          return this.createToolView();
        }
      };

      ToolContainer.prototype.render = function() {
        var _ref;
        this.$el.html((_ref = this.toolView) != null ? _ref.render().el : void 0);
        return this;
      };

      return ToolContainer;

    })(Backbone.View);

    module.exports = ToolContainer;

  }).call(this);
  
}});

window.require.define({"views/tool_window": function(exports, require, module) {
  (function() {
    var Settings, ToolContainer, ToolWindow, WindowTitleBar,
      __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
      __hasProp = {}.hasOwnProperty,
      __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

    Settings = require('views/settings');

    ToolContainer = require('views/tool_container');

    WindowTitleBar = require('views/window_title_bar');

    ToolWindow = (function(_super) {

      __extends(ToolWindow, _super);

      function ToolWindow() {
        this.endDrag = __bind(this.endDrag, this);

        this.startDrag = __bind(this.startDrag, this);

        this.close = __bind(this.close, this);

        this.toggleSettings = __bind(this.toggleSettings, this);

        this.render = __bind(this.render, this);

        this.setWindowSize = __bind(this.setWindowSize, this);

        this.setWindowPosition = __bind(this.setWindowPosition, this);

        this.initialize = __bind(this.initialize, this);
        return ToolWindow.__super__.constructor.apply(this, arguments);
      }

      _.extend(ToolWindow.prototype, Backbone.Events);

      ToolWindow.prototype.tagName = 'div';

      ToolWindow.prototype.className = 'tool-window';

      ToolWindow.prototype.initialize = function() {
        if (this.model != null) {
          this.model.on('change:top change:left', this.setWindowPosition);
          this.model.on('change:width change:height', this.setWindowSize);
          this.setWindowPosition();
          this.setWindowSize();
        }
        this.settings = new Settings({
          model: this.model
        });
        this.toolContainer = new ToolContainer({
          model: this.model
        });
        this.titleBar = new WindowTitleBar({
          model: this.model
        });
        this.titleBar.on('close', this.close);
        this.titleBar.on('settings', this.toggleSettings);
        this.titleBar.on('startDrag', this.startDrag);
        return this.titleBar.on('endDrag', this.endDrag);
      };

      ToolWindow.prototype.setWindowPosition = function() {
        this.$el.css('left', this.model.get('left'));
        return this.$el.css('top', this.model.get('top'));
      };

      ToolWindow.prototype.setWindowSize = function() {
        this.$el.css('height', this.model.get('height'));
        return this.$el.css('width', this.model.get('width'));
      };

      ToolWindow.prototype.render = function() {
        var _this = this;
        _.each([this.titleBar, this.settings, this.toolContainer], function(section) {
          return _this.$el.append(section.render().el);
        });
        return this;
      };

      ToolWindow.prototype.toggleSettings = function() {
        return this.$el.toggleClass('settings-active');
      };

      ToolWindow.prototype.close = function(e) {
        this.model.destroy();
        return this.remove();
      };

      ToolWindow.prototype.startDrag = function(e) {
        var mouseOffset, relX, relY,
          _this = this;
        this.$el.addClass('unselectable');
        this.dragging = true;
        mouseOffset = this.$el.offset();
        relX = e.pageX - mouseOffset.left;
        relY = e.pageY - mouseOffset.top;
        return $(document).on('mousemove', function(e) {
          if (_this.dragging) {
            return _this.model.set({
              left: e.pageX - relX,
              top: e.pageY - relY
            });
          }
        });
      };

      ToolWindow.prototype.endDrag = function(e) {
        this.$el.removeClass('unselectable');
        this.dragging = false;
        return $(document).off('mousemove');
      };

      return ToolWindow;

    })(Backbone.View);

    module.exports = ToolWindow;

  }).call(this);
  
}});

window.require.define({"views/toolbox": function(exports, require, module) {
  (function() {
    var Toolbox,
      __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
      __hasProp = {}.hasOwnProperty,
      __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

    Toolbox = (function(_super) {

      __extends(Toolbox, _super);

      function Toolbox() {
        this.removeTools = __bind(this.removeTools, this);

        this.createTool = __bind(this.createTool, this);

        this.render = __bind(this.render, this);
        return Toolbox.__super__.constructor.apply(this, arguments);
      }

      _.extend(Toolbox.prototype, Backbone.Events);

      Toolbox.prototype.tagName = 'div';

      Toolbox.prototype.className = 'toolbox';

      Toolbox.prototype.template = require('./templates/toolbox');

      Toolbox.prototype.tools = [
        {
          name: 'Table',
          description: 'displays data in a tabular format'
        }
      ];

      Toolbox.prototype.events = {
        'click .tool-icon button': 'createTool',
        'click button[name="remove-tools"]': 'removeTools'
      };

      Toolbox.prototype.render = function() {
        this.$el.html(this.template({
          tools: this.tools
        }));
        return this;
      };

      Toolbox.prototype.createTool = function(e) {
        var toolType;
        toolType = $(e.currentTarget).attr('name');
        return this.trigger("create-" + toolType);
      };

      Toolbox.prototype.removeTools = function(e) {
        return this.trigger("remove-tools");
      };

      return Toolbox;

    })(Backbone.View);

    module.exports = Toolbox;

  }).call(this);
  
}});

window.require.define({"views/window_title_bar": function(exports, require, module) {
  (function() {
    var WindowTitleBar,
      __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
      __hasProp = {}.hasOwnProperty,
      __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

    WindowTitleBar = (function(_super) {

      __extends(WindowTitleBar, _super);

      function WindowTitleBar() {
        this.updateModel = __bind(this.updateModel, this);

        this.editTitle = __bind(this.editTitle, this);

        this.endDrag = __bind(this.endDrag, this);

        this.startDrag = __bind(this.startDrag, this);

        this.settings = __bind(this.settings, this);

        this.close = __bind(this.close, this);

        this.render = __bind(this.render, this);
        return WindowTitleBar.__super__.constructor.apply(this, arguments);
      }

      _.extend(WindowTitleBar.prototype, Backbone.Events);

      WindowTitleBar.prototype.tagName = 'div';

      WindowTitleBar.prototype.className = 'title-bar';

      WindowTitleBar.prototype.template = require('./templates/window_title_bar');

      WindowTitleBar.prototype.events = {
        'click .window-close': 'close',
        'click .open-settings': 'settings',
        'dblclick .window-title': 'editTitle',
        'keypress input[name="window-title"]': 'updateModel',
        'blur input[name="window-title"]': 'updateModel',
        'mousedown': 'startDrag',
        'mouseup': 'endDrag'
      };

      WindowTitleBar.prototype.initialize = function() {
        var _ref;
        return (_ref = this.model) != null ? _ref.on('change:name', this.render) : void 0;
      };

      WindowTitleBar.prototype.render = function() {
        var title, _ref;
        title = (_ref = this.model) != null ? _ref.get('name') : void 0;
        this.$el.html(this.template({
          name: title
        }));
        return this;
      };

      WindowTitleBar.prototype.close = function() {
        return this.trigger('close');
      };

      WindowTitleBar.prototype.settings = function() {
        return this.trigger('settings');
      };

      WindowTitleBar.prototype.startDrag = function(e) {
        return this.trigger('startDrag', e);
      };

      WindowTitleBar.prototype.endDrag = function(e) {
        return this.trigger('endDrag', e);
      };

      WindowTitleBar.prototype.editTitle = function() {
        this.$('.window-title').hide();
        return this.$('input').show();
      };

      WindowTitleBar.prototype.updateModel = function(e) {
        var input, newTitle;
        if (e.type === 'focusout' || e.which === 13) {
          input = this.$('input');
          newTitle = input.val();
          if (newTitle === this.model.get('name')) {
            this.$('.window-title').show();
            return this.$('input').hide();
          } else {
            return this.model.set('name', newTitle);
          }
        }
      };

      return WindowTitleBar;

    })(Backbone.View);

    module.exports = WindowTitleBar;

  }).call(this);
  
}});

