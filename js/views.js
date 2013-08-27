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
        .html(_.bind(function(d) { console.log(d); return this.template(d) }, this));

      this.list.exit().remove();

      return this;
    }
  };

  Dashboard.IndexPage = Backbone.View.extend(_.extend({
    el: "#index", 

    initialize: function() {
      this.projectName = this.$('.name');
      this.listenTo(Dashboard.State, 'change:project', this.updateProject);
      User.on('initialized', _.bind(function() {
        this.listenTo(User.current.collections, 'add reset', this.updateCollections);
      }, this));
      this.updateProject(null, Dashboard.State.get('project'));
    },

    events: {
      'change select.project' : 'setProject',
      'click button#create-dashboard' : 'createDashboard'
    },

    createDashboard: function(ev) {
      User.current.dashboards
      .create({name: this.$('#dashboard-name').val(), project: Dashboard.State.get('project')});
    },

    setProject: function(ev) {
      if (ev.target.value === '')
        return;
      else
        Dashboard.State.set('project', ev.target.value);
    },

    updateCollections: function(_, collections) {
      collections.each(function(col) {
        this.$('select.talk-collections')
        .append('<option value="' + col.id + '">' + col.get('title') + '</option>');
      }, this);
    },

    updateProject: function(state, project) {
      if (project) {
        this.$('.project-selected').show();
        this.$('select.project').val(project);
        this.projectName.text(Dashboard.projects[project].name);
      } else {
        this.$('.project-selected').hide();
      }
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
      dashboard: "#dashboard", 
      saved: new Dashboard.Saved, 
      data: new Dashboard.Data
    },

    initialize: function() {
      this.active = this.$('#index');
      this.listenTo(this.model, 'change:page', this.setActive);
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

  Dashboard.Header = Backbone.View.extend({
    el: "header",
    active: null,

    sections: {
      index: null,
      dashboard: "#nav-dashboard", 
      saved: "#nav-saved", 
      data: "#nav-data"
    },

    events: {
      "click #current-project" : 'toggleProjects'
    },

    initialize: function() {
      this.activeProject = this.$('#current-project .name');
      this.projectSelect = this.$('#project-select');
      this.listenTo(this.model, 'change:project', this.updateProject);
      this.listenTo(this.model, 'change:page', this.setActive);
      this.listenTo(this.model, 'change:currentDashboard', this.setDashboard);
    },

    toggleProjects: function() {
      this.projectSelect.toggle();
    },

    setActive: function(state, active) {
      active = this.sections[active];
      if (!_.isNull(this.active))
        this.active.removeClass("active");
      if (_.isNull(active))
        this.active = null;
      this.active = this.$(active);
      this.active.addClass("active");
    },

    setDashboard: function(state, id) {
      curAnchor = this.$('#current-dashboard a');
      curAnchor.attr('href', curAnchor.attr('href') + "/" + id);
    },

    updateProject: function(state, project) {
      var projectText;
      // Hide Project Select in case it's open
      this.projectSelect.hide();

      // Update Anchor Tags with new Project
      var anchors = this.$('span a');
      var hrefs = _.map(anchors, function(a) { 
        var href = a.getAttribute('href');
        href = href.split('/');
        return [_.first(href), project, _.last(href)].join('/');
      });
      anchors.each(function(i) {this.setAttribute('href', hrefs[i])});

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
