module.exports = {
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

    this.list.exit().transition().style('opacity', 0).remove();

    return this;
  }
};
