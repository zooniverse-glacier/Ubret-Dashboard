var state = require("lib/state"),
  User = zooniverse.models.User;

module.exports = {
  tool_chain: {
    project: function() { return state.get('project'); },
    title: "Double Click to Edit Title",
    annotation : "Double Click to Edit Annotation"
  }
}
