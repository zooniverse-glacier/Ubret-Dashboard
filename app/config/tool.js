var state = require("lib/state"),
  User = zooniverse.models.User;

module.exports = {
  tool_chain: {
    settings : {
      project: function() { return state.get('project'); },
      title: "Double Click to Edit Title",
      annotation : "Double Click to Edit Annotation"
    },
    persistedState: ['id', 'user', 'project']
  },
  table: {
    settings: {
      currentPage: 0,
      sortColumn: 'uid',
      sortOrder: 'a'
    },
    persistedState: ['currentPage', 'sortOrder', 'sortColumn']
  }
}
