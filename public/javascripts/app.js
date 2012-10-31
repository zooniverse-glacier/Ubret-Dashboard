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

window.require.define({"models/dashboard": function(exports, require, module) {
  (function() {
    var Dashboard, Tools,
      __hasProp = {}.hasOwnProperty,
      __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

    Tools = require('collections/tools');

    Dashboard = (function(_super) {

      __extends(Dashboard, _super);

      function Dashboard() {
        return Dashboard.__super__.constructor.apply(this, arguments);
      }

      Dashboard.prototype.defaults = {
        "tools": new Tools
      };

      Dashboard.prototype.urlRoot = '/dashboard';

      Dashboard.prototype.parse = function(response) {
        response.tools = new Tools(response.tools);
        return response;
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
      __hasProp = {}.hasOwnProperty,
      __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

    DataSource = require('models/data_source');

    Filters = require('collections/filters');

    Tool = (function(_super) {

      __extends(Tool, _super);

      function Tool() {
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

      return Tool;

    })(Backbone.Model);

    module.exports = Tool;

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
        this.createToolWindow = __bind(this.createToolWindow, this);

        this.render = __bind(this.render, this);
        return DashboardView.__super__.constructor.apply(this, arguments);
      }

      DashboardView.prototype.tagName = 'div';

      DashboardView.prototype.className = 'dashboard';

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

      DashboardView.prototype._setToolWindow = function(toolWindow) {
        return ToolWindow = toolWindow;
      };

      return DashboardView;

    })(Backbone.View);

    module.exports = DashboardView;

  }).call(this);
  
}});

window.require.define({"views/settings": function(exports, require, module) {
  (function() {
    var Settings,
      __hasProp = {}.hasOwnProperty,
      __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

    Settings = (function(_super) {

      __extends(Settings, _super);

      function Settings() {
        return Settings.__super__.constructor.apply(this, arguments);
      }

      return Settings;

    })(Backbone.View);

    module.exports = Settings;

  }).call(this);
  
}});

window.require.define({"views/tool_container": function(exports, require, module) {
  (function() {
    var ToolContainer,
      __hasProp = {}.hasOwnProperty,
      __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

    ToolContainer = (function(_super) {

      __extends(ToolContainer, _super);

      function ToolContainer() {
        return ToolContainer.__super__.constructor.apply(this, arguments);
      }

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
          this.model.on('change', this.setWindowPosition);
          this.model.on('change', this.setWindowSize);
          this.setWindowPosition();
          this.setWindowSize();
        }
        this.settings = new Settings(this.model);
        this.toolContainer = new ToolContainer(this.model);
        this.titleBar = new WindowTitleBar(this.model);
        this.titleBar.on('close', this.close);
        return this.titleBar.on('settings', this.toggleSettings);
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

      ToolWindow.prototype.close = function() {
        this.model.destroy();
        return this.remove();
      };

      return ToolWindow;

    })(Backbone.View);

    module.exports = ToolWindow;

  }).call(this);
  
}});

window.require.define({"views/window_title_bar": function(exports, require, module) {
  (function() {
    var WindowTitleBar,
      __hasProp = {}.hasOwnProperty,
      __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

    WindowTitleBar = (function(_super) {

      __extends(WindowTitleBar, _super);

      function WindowTitleBar() {
        return WindowTitleBar.__super__.constructor.apply(this, arguments);
      }

      _.extend(WindowTitleBar.prototype, Backbone.Events);

      WindowTitleBar.prototype.tagName = 'div';

      WindowTitleBar.prototype.className = 'title-bar';

      return WindowTitleBar;

    })(Backbone.View);

    module.exports = WindowTitleBar;

  }).call(this);
  
}});

