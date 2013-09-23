SimpleTreeView = Backbone.View.extend({
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

module.exports = SimpleTreeView;
