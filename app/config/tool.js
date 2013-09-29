var state = require("lib/state"),
  User = zooniverse.models.User;

module.exports = {
  tool_chain: {
    settings : {
      project: function() { return state.get('project'); },
      title: "Double Click to Edit Title",
      annotation : "Double Click to Edit Annotation"
    },
    persistedState: ['id', 'user', 'project', 'title', 'annotation']
  },
  table: {
    settings: {
      currentPage: 0,
      sortColumn: 'uid',
      sortOrder: 'a'
    },
    persistedState: ['currentPage', 'sortOrder', 'sortColumn', 'selection']
  },
  prompt: {
    settings: {},
    persistedState: ['statements']
  },
  scatterplot: {
    settings: {},
    persistedState: ['xAxis', 'yAxis', 'xMin', 'xMax', 'yMin', 'yMax', 'selection']
  },
  statistics: {
    settings: {},
    persistedState: ['key']
  }
}
