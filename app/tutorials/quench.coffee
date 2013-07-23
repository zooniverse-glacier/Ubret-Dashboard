{Step} = zootorial

module.exports = new zootorial.Tutorial 
  id: 'quench_dashboard_tutorial'
  firstStep: 'welcome'
  steps:
    welcome: new Step
      header: "Welcome"
      details: "Let's learn about the Quench Dashboard."
      nextButton: 'Start Tutorial'
      next: 'data1'
    data1: new Step
              header: 'Accessing Data'
              details: "Before Dashboard can be used we must import data.  Let's access a collection from Talk.<br><br>Click 'Data'."
              attachment: 'left center a[data-drawer="data"] 2.0 .5'
              className: 'arrow-left'
              next:
                'click li a[data-drawer="data"]': 'data2'
    data2: new Step
              header: 'Zooniverse Data'
              details: 'Specify "Zooniverse" as the data source.'
              attachment: 'left center a[data-tool="Zooniverse"] 1.0 1.5'
              className: 'arrow-left'
              next:
                'click a[data-tool="Zooniverse"]': 'data3'
    data3: new Step
              header: 'Recents, Favorites, and Talk Collections'
              details: "You can access data from Recents, Favorites, or any Talk collection.<br><br>Click 'Collections' to import from Talk."
              attachment: 'center center .tool-window center center'
              next:
                'click a[data-target="collections"]': 'data4'
    data4: new Step
              header: 'Talk Collection'
              details: 'Select the "Quench Sample" collection. This is our 3,002 post-quenched galaxy sample. Notice the "Control Sample" collection that contains data on the 3,002 mass and reshift matched control galaxies.'
              attachment: 'right center .collections > label left center'
              className: 'arrow-right'
              next:
                'change select.user-collection': 'data5'
    data5: new Step
              header: 'Import'
              details: 'Click "Import".'
              attachment: 'right center button.import left center'
              className: 'arrow-right'
              next:
                'click button.import': 'tool'
    tool: new Step
              header: 'Tool'
              details: "Great! We have just connected a Talk collection to Dashboard.  Now let's connect a tool.<br><br>Click 'Tools'."
              attachment: 'left center a[data-drawer="tool"] 2.0 .5'
              className: 'arrow-left'
              next:
                'click li a[data-drawer="tool"]': 'table1'
    table1: new Step
              header: 'Table'
              details: 'Click "Table" to view information about all the galaxies in your Collection.'
              attachment: 'left center a[data-tool="Table"] 1.0 0.5'
              className: 'arrow-left'
              next: 'click a[data-tool="Table"]' : 'table2'
    table2: new Step
              header: 'Table'
              onEnter: (t) ->
                title = $('.window-title').first().text().trim()
                setTimeout ( =>
                  details = t.el.find('.details')
                  text = @details.replace("{{title}}", title)
                  details.html(text)
                ), 0
              details: 'This tool is used for viewing information about all the galaxies in your collection. <p> First connection a data source by selecting "{{title}}" from "Select Tool".</p>'
              attachment: 'center center .Table center center'
              next:
                'change select.sources': 'table3'

    table3: new Step
              header: 'Table'
              details: 'Each row corresponds to a different galaxy in your Collection. <p> To maniuplate the data in your table you can use the \'Prompt\'.</p>'
              attachment: 'center center .Table center center'
              nextButton: 'Next'
              next: 'prompt1'

    prompt1: new Step
              header: 'Prompt'
              details: 'To create a column u_man - g_mag color, type "New Field \'u-g color\', .u - .g" in the Prompt, and click "Execute".'
              attachment: 'right center button.fql-submit left center'
              className: 'arrow-right'
              next: 'click button.fql-submit' : 'prompt2'

    prompt2: new Step
              header: 'Prompt'
              details: 'Notice how the new column has been added to the end of the Table.'
              attachment: 'right center button.fql-submit left center'
              nextButton: "Let's make a Graph"
              next: 'scatter1'

    scatter1: new Step
              header: 'Scatter Plot'
              details: "Great! You now have a sense for the data we have for each source in this Collection and you've derived a new column of data. <p> Click 'Scatter Plot' to loko for trends in the data.</p>"
              attachment: 'left center a[data-tool="Scatterplot"] 1.0 0.5'
              className: 'arrow-left'
              next: 'click a[data-tool="Scatterplot"]' : 'scatter2'
    scatter2: new Step
              header: 'Scatter Plot'
              onEnter: (t) ->
                title = $('.window-title').text().trim()[1]
                setTimeout ( =>
                  details = t.el.find('.details')
                  text = @details.replace("{{title}}", title)
                  details.html(text)
                ), 0
              details: 'This tool is used for creating Scatter Plots. <p> First connection a data source by selecting "{{title}}" from "Select Tool".</p>'
              attachment: 'center center .Scatterplot center center'
              next: 'change select.sources' : 'scatter3'
    scatter3: new Step
              header: 'Scatter Plot'
              details: 'Select log-mass for the x-axis'
              attachment: 'right center select.x-axis left center'
              className: 'arrow-right'
              next: 'change select.x-axis' : 'scatter4'
    scatter4: new Step
              header: 'Scatter Plot'
              details: 'Select u-g color for the y-axis'
              attachment: 'right center select.y-axis left center'
              className: 'arrow-right'
              next: 'change select.y-axis' : 'scatter5'
    scattter5: new Step
              header: 'Scatter Plot'
              details: 'Click the Settings Arrow to see your whole graph'
              attachment: 'center top .window:has(.Table) .toggle center top'
              className: 'arrow-bottom'
              next: 'click .toggle' : 'finish'
    finish: new Step
              header: 'Finished!'
              details: "Congrat! You've derived new data and created your first plot."
