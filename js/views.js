(function()  {
  "use strict";
  var Dashboard = this.Dashboard;
  var User = this.User;

  Dashboard.ToggleView = {
    hide: function() {
      this.$el.hide();
    },

    show: function() {
      this.$el.show();
      this.render();
    }
  };

  Dashboard.ToggleListLayout = {
    setListClass: function(state, type) {
      var changed = state.previous('list-type');
      if (changed) {
        this.$el.removeClass(changed);
        this.$('button[data-type="' + changed + '"]').removeClass('active');
      }
      this.$('button[data-type="' + type + '"]').addClass('active');
      this.$el.addClass(type);
    },

    setListType: function(e) {
      Dashboard.State.set('list-type', e.target.dataset.type);
    },

    render: function() {
      if (!this.collection)
        return 

      this.list = d3.select(this.el)
        .select('.list-container')
        .selectAll('.listing')
        .data(this.collection.models, function(d) { return d.id; });

      this.list.enter().append('div')
        .attr('class', 'listing')
        .html(_.bind(function(d) { return this.template(d) }, this));

      this.list.exit().remove();

      return this;
    }
  };

  Dashboard.DashboardView = Backbone.View.extend(_.extend({
    el: '#dashboard',

    initialize: function() {
      User.on('initialized', _.bind(function() {
        this.collection = User.current.dashboards;
      }, this));
      this.listenTo(Dashboard.State, 'change:currentDashboard', this.updateDashboard);
      this.model = Dashboard.State.get('currentDashboard');
      if (this.model) {
        this.sidebarTree = new Dashboard.SimpleTreeView({model: this.model}).render();
        this.render();
      }
    },

    treeLayout: d3.layout.tree(),

    render: function() {
      if (!this.model)
        return;
      var treeLayout = _.map(this.model.get('tools').toTree(), this.treeLayout);
    },

    updateDashboard: function(state, model) {
      this.$(".section-header h2").text(model.get('name'));
      this.model = model;
      this.sidebarTree == new Dashboard.SimpleTreeView({model: this.model}).render();
      this.render();
    }
  }, Dashboard.ToggleView));

  Dashboard.SimpleTreeView = Backbone.View.extend({
    el: '#tree-drawer',

    events: { 
      'click .toggle' : 'toggle'
    },

    initailize: function() {
      this.listenTo(this.model, 'add:tools remove:tools create:tools reset:tools', this.render);
    },

    toggle: function() {
      this.$el.toggleClass('active');
    },

    treeLayout: d3.layout.tree(),

    render: function() {
      var layout = _.map(this.model.get('tools').toTree(), this.treeLayout.nodes)

      var tree = d3.select(this.el).selectAll('ul.tree')
        .data(layout, function(d) { return d[0]._id; });

      tree.enter().append('ul')
        .attr('class', 'tree')

      tree.append('li')
          .attr('data-tool-id', function(d) { return d._id })
          .text(function(d) { return d.name; });

      var leaves = tree.selectAll('li')
        .data(function(d) { return d; }, function(d) { return d._id; })

      leaves.enter().append('li')
        .attr('data-tool-id', function(d) { return d._id })
        .style('padding-left', function(d) { return d.depth * 10 + "px"; })
        .text(function(d) { return d.name; });

      leaves.exit().remove();
      
      tree.exit().remove();
    }
  });

  Dashboard.Create = Backbone.View.extend({
    template: $("#new-dashboard").html(),

    initialize: function() {
      this.listenTo(Dashboard.State, 'change:project', this.setSelected);
      this.listenTo(this.collection, 'add reset', this.render);
    },

    events: {
      'click .create-dashboard-go' : 'createDashboard'
    },

    setSelected: function() {
      this.$('.create-dashboard-project').val(Dashboard.State.get('project'));
    },

    createDashboard: function(ev) {
      var newDashboard = User.current.dashboards.create({
        name: this.$('.create-dashboard-name').val(), 
        project: this.$('.create-dashboard-project').val()
      }, {wait: true})
      newDashboard.once('sync', function(m) {
        var url = "#/" + m.get('project') + "/dashboards/" + m.id;
        Dashboard.router.navigate(url, {trigger: true});
      });
    },

    render: function() {
      this.$el.html(this.template);
      var projects = [['', {name: 'Choose a project'}]]
        .concat(_.pairs(Dashboard.projects))

      var collections = [{id: '', get: function() { return 'No Data Please' }}]
        .concat(this.collection.models);

      var projectOptions = d3.select(this.el)
        .select('.create-dashboard-project').selectAll('option')
        .data(projects, function(d) { return d[0]});

      var dataOptions = d3.select(this.el)
        .select('.create-dashboard-data').selectAll('option')
        .data(collections, function(d) { return d.id });

      projectOptions.enter().append('option')
        .attr('value', function(d) { return d[0] })
        .text(function(d) {return d[1].name});

      projectOptions.exit().remove();

      dataOptions.enter().append('option')
        .attr('value', function(d) { return d.id; })
        .text(function(d) { return d.get('title'); });

      dataOptions.exit().remove();

      this.setSelected();
      return this;
    }
  });

  Dashboard.IndexPage = Backbone.View.extend(_.extend({
    el: "#index", 

    template: _.template($('#welcome-overlay').html()),

    initialize: function() {
      this.projectName = this.$('.name');
      User.on('initialized', _.bind(function() {
        this.collection = User.current.dashboards;
        this.dashboardCreate = new Dashboard.Create({collection: User.current.collections});
        this.render();
        this.listenTo(this.collection, 'add reset', this.updateRecents);
      }, this));
    },

    events: {
      'change select.project' : 'setProject',
    },

    setProject: function(ev) {
      if (ev.target.value === '')
        return;
      else
        Dashboard.State.set('project', ev.target.value);
    },

    updateRecents: function() {
      var recents = d3.select(this.el).select('#welcome-recents').selectAll('li')
        .data(this.collection.models.slice(0,3), function (d) { return d.id });
     
      recents.enter().append('li')
        .append('a')
        .attr('href', function(d) { 
          return "#/" + d.get('project') + "/dashboards/" + d.id 
        })
        .html(function(d) { 
          var name = '<span class="name">' + d.get('name') + '</span>';
          var data = '<span class="date">' + d.getFormattedDate('updated_at') + '</span>'
          return name + data;
        });

      recents.exit().remove();
    },

    render: function() {
      if (!User.current)
        return;

      // Render Welcome Template
      this.$('.logged-in').html(this.template({project: Dashboard.State.get('project')}));
      this.$('#welcome-create').html(this.dashboardCreate.render().el);

      if (!_.isEmpty(User.current.dashboards))
        this.updateRecents();

      return this;
    }
  }, Dashboard.ToggleView));


  Dashboard.Saved = Backbone.View.extend(_.extend({
    el: "#saved",

    template: _.template($('#dashboard-list-template').html()),

    initialize: function() {
      User.on('initialized', _.bind(function() {
        this.collection = User.current.dashboards; 
        this.listenTo(this.collection, 'add reset', this.render);
      }, this));
      this.listenTo(Dashboard.State, 'change:list-type', this.setListClass);
      this.setListClass(Dashboard.State, Dashboard.State.get('list-type'));
    },

    events: {
      'click .layouts button' : 'setListType',
    }
  }, Dashboard.ToggleView, Dashboard.ToggleListLayout));

  Dashboard.Data = Backbone.View.extend(_.extend({
    el: '#data',

    template: _.template($('#data-list-template').html()),

    events: {
      'click .layouts button' : 'setListType',
    },

    initialize: function() {
      User.on('initialized', _.bind(function() {
        this.collection = User.current.collections;
        this.listenTo(this.collection, 'add reset', this.render);
      }, this));
      this.listenTo(Dashboard.State, 'change:list-type', this.setListClass);
      this.setListClass(Dashboard.State, Dashboard.State.get('list-type'));
    }
  }, Dashboard.ToggleView, Dashboard.ToggleListLayout));

  Dashboard.App = Backbone.View.extend({
    el: "#app",

    sections: {
      index: new Dashboard.IndexPage, 
      dashboard: new Dashboard.DashboardView,
      saved: new Dashboard.Saved, 
      data: new Dashboard.Data
    },

    initialize: function() {
      this.active = this.$('#index');
      this.listenTo(this.model, 'change:page', this.setActive);
      this.listenTo(this.model, 'change:project', this.redirect);
    },

    setActive: function(state, active) {
      var section = this.sections[active];
      if (_.isUndefined(section))
        throw new Error("Section doesn't exist");
      this.active.hide();
      this.active = this.sections[active];
      this.active.show();
    }

  });

  Dashboard.Menu = Backbone.View.extend({
    el: '#menu-panel',

    events: {
      'click li' : 'navigateTo'
    },

    pages: {
      'saved' : '#saved-dashboards',
      'dashboard' : '#current-dashboard',
      'data' : '#saved-data'
    },

    initialize: function() {
      this.menuItems = this.$('a');
      this.listenTo(this.model, 'change:project', this.updateProject);
      this.listenTo(this.model, 'change:page', this.updateActive);
      this.listenTo(this.model, 'change:currentDashboard', this.updateDashboard);
    },

    updateDashboard: function(state, dashboard) {
      if (!dashboard) {
        this.$('#copy-dashboard, #current-dashboard').addClass('disabled');
        return;
      }
      this.$('#copy-dashboard, #current-dashboard').removeClass('disabled');
    },

    updateActive: function(state, page) {
      if (this.active)
        this.active.removeClass('active');
      this.active = this.$(this.pages[page]);
      this.active.addClass('active');
    },

    navigateTo: function(ev) {
      var navigate = _.bind(function(destination) {
        Dashboard.router.navigate('#/' + this.model.get('project') + destination, { trigger: true })
      }, this);

      ev = $(ev.target);

      if (ev.hasClass('disabled'))
        return;
      else if (ev.attr('id') === 'saved-dashboards')
        navigate('/dashboards');
      else if (ev.attr('id') === 'saved-data')
        navigate('/data');
      else if (ev.attr('id') === 'current-dashboard')
        navigate('/dashboards/' + this.model.get('currentDashboard').id);
      else if (ev.attr('id') === 'copy-dashboard')
        this.model.get('currentDashboard').copy().then(function(response) {
          navigate('/dashboards/' + response.id)
        });
      else if (ev.attr('id') === 'new-dashboard')
        new Dashboard.CreateDashboardDialog().then(function(model) {
          navigate('/dashboards/' + model.id)
        });

      $('#menu').toggleClass('active');
      this.toggle();
    },

    toggle: function() {
      this.$el.toggleClass('active');
    }
  });

  Dashboard.Header = Backbone.View.extend({
    el: "header",
    active: null,

    events: {
      "click #current-project" : 'toggleProjects',
      "click #menu" : "toggleMenu"
    },

    initialize: function() {
      this.activeProject = this.$('#current-project .name');
      this.projectSelect = this.$('#project-select');
      this.menu = new Dashboard.Menu({model: this.model});
      this.listenTo(this.model, 'change:project', this.updateProject);
    },

    toggleProjects: function() {
      this.projectSelect.toggle();
    },

    toggleMenu: function() {
      this.$('#menu').toggleClass('active');
      this.menu.toggle();
    },

    updateProject: function(state, project) {
      var projectText;
      // Hide Project Select in case it's open
      this.projectSelect.hide();

      // Update the Active Project
      if (!project) {
        projectText = 'No Project';
      } else {
        // Hide the Active Project from the List
        if (!_.isUndefined(this.hiddenProject))
          this.hiddenProject.show(); 
        this.hiddenProject = this.projectSelect.find('#' + project).hide();
        projectText = Dashboard.projects[project].name;
      }
      this.activeProject.text(projectText);
    }
  });
}).call(this);
