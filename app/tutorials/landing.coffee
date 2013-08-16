Step = zootorial.Step

module.exports = new zootorial.Tutorial
  id: "landing_tutorial"
  firstStep: 'welcome'
  steps:
    welcome: new Step
              header: 'Welcome to Zoo Tools'
              details: "Login to get started."
              nextButton: 'Start Tutorial'
              next: 'selectProject'
    selectProject: new Step
              header: "Select a project"
              details: "Select a project that you would like to explore."
              attachment: "left center div.active-project 1.2 center"
              className: 'arrow-left'
              next:
                'click li.project, div.active-project': 'createDashboard'
    createDashboard: new Step
              header: 'Create Dashboard'
              details: 'Zoo Tools uses "Dashboards" to organize your work. To start, click Create Dashboard.'
              attachment: 'center -0.2 button.create-dashboard center bottom'
              className: 'arrow-top'