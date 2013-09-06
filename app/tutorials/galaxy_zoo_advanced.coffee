{Step} = zootorial

module.exports = new zootorial.Tutorial 
  id: 'galaxy_zoo_advanced_tutorial'
  firstStep: 'scatterplot5'
  steps:
    welcome: new Step
      header: "Welcome to zootools!"
      details: "zootools is a website designed to let you explore data from our citizen science projects. This short tutorial will demonstrate some advanced features for the site using data from Galaxy Zoo."
      nextButton: 'Start Tutorial'
      next: 'data1'
    data1: new Step
              header: 'Loading Data'
              details: "The first step in zootools is to load data into your Dashboard.<br><br>Start by clicking on the <b>Data</b> tab."
              attachment: 'center top a[data-drawer="data"] center 2.0'
              className: 'arrow-top'
              next: 'click li a[data-drawer="data"]': 'data2'
    data2: new Step
              header: 'Loading Data'
              details: "For Galaxy Zoo, you can either select data classified by Galaxy Zoo (<b>Zooniverse</b>) or load external data from the Sloan Digital Sky Survey (<b>Skyserver</b>).<br><br>For now, let’s select <b>SkyServer</b>."
              attachment: 'left top a[data-tool="Sky Server"] 0.0 3.0'
              #className: 'arrow-top'
              next: 'click li a[data-tool="Sky Server"]': 'data3'
    data3: new Step
              header: 'Loading Data'
              details: "We're going to search for galaxies near a specific location on the sky. Select 'area' from the <b>Search Types</b> menu."
              attachment: 'center bottom select.search_types center -2.0'
              className: 'arrow-bottom'
              next: 'change select.search_types': 'data4'
    data4: new Step
              header: 'Loading Data'
              details: "The <b>RA</b> and <b>Dec</b> sliders are used to select the coordinates on the sky near which we're searching for galaxies. Try something like RA=183 and Dec = 24."
              attachment: 'center bottom select.search_types center -2.0'
              className: 'arrow-bottom'
              next: 'data5'
              nextButton: 'Next'
    data5: new Step
              header: 'Loading Data'
              details: "The <b>Radius</b> field defines how big of a circle we're searching within, centered on the point you picked. Try 10 arcminutes."
              attachment: 'left center div.column.three-quarters right center'
              className: 'arrow-left'
              next: 'data6'
              nextButton: 'Next'
    data6: new Step
              header: 'Loading Data'
              details: "... and let's <b>limit</b> our results to 100 galaxies."
              attachment: 'left center div.column.three-quarters right center'
              className: 'arrow-left'
              next: 'data7'
              nextButton: 'Next'
    data7: new Step
              header: 'Loading Data'
              details: "Click <b>Load Data</b> to run your search and download the data from the SkyServer."
              attachment: 'left center button.action.load right center'
              className: 'arrow-left'
              #next: 'click button.action.load': 'table1'
              next: 'table1'
              nextButton: 'Continue'
    table1: new Step
              header: 'Creating New Data Columns'
              details: "Great - you've imported the data to your Dashboard! Let’s use the Table tool to take a look at the dataset.<br><br>First, switch from Data to the <b>Tools</b> tab, then select <b>Table</b>."
              attachment: 'left top a[data-drawer="tool"] 0.0 3.5'
              next: 'click a[data-tool="Table"]': 'table2'
    table2: new Step
              header: 'Table'
              details: "To use the Table, we need to connect it to the data. In the <b>Data Source</b> menu, choose the data set you just imported (which should be named `Skyserver-1')."
              attachment: 'left center select.sources 1.2 0.0'
              className: 'arrow-left'
              next: 'change select.sources': 'table3'
    table3: new Step
              header: 'Table'
              details: "Each row corresponds to a different galaxy in your collection, while the columns show the data available for each galaxy. We're going to create a new data column by combining two of the existing ones."
              attachment: 'left center select.sources 1.2 0.0'
              nextButton: 'Next'
              next: 'table4'
    table4: new Step
              header: 'Table'
              details: "Data from the SkyServer includes brightnesses for the galaxy in various bands, which are called <i>magnitudes</i>. We're going to combine two of them to create a data column for the <i>color</i> of the galaxy, using the <b>Prompt</b> box."
              attachment: 'left center input.full.fql-box right center'
              className: 'arrow-left'
              nextButton: 'Next'
              next: 'table5'
    table5: new Step
              header: 'Table'
              details: "In the <b>Prompt</b> box, type in the phrase:<br><br>field 'color', .g - .r<br><br>This makes a new field called <i>color</i>, the values of which are taken by subtracting the r-band from the g-band magnitude for each galaxy.<br><br>Click <b>Execute</b> to create the new column."
              attachment: 'left center input.full.fql-box right center'
              className: 'arrow-left'
              next: 'click button.action.column.one-half.fql-submit' : 'table6'
    table6: new Step
              header: 'Table'
              details: "Scroll to the right in the <b>Table</b>, and you'll see that the new column has been added to the end."
              attachment: 'left center input.full.fql-box right center'
              nextButton: 'Next'
              next: 'scatterplot1'
    scatterplot1: new Step
              header: 'Plotting data'
              details: "Now that we've computed the color for each of our galaxies, let's see how this depends on other parameters. To do this, let's use the <b>Scatterplot</b> tool.<br><br>Select <b>Scatterplot</b> from under the <b>Tools</b> tab."
              attachment: 'left top a[data-drawer="tool"] 0.0 3.5'
              next: 'click a[data-tool="Scatterplot"]': 'scatterplot2'
    scatterplot2: new Step
              header: 'Plotting data'
              details: "As before, connect the data you want to plot to the new tool using the <b>Data Source</b> menu. Since you want to use the new column you made in the Table, select `Table-2'."
              attachment: 'left center select.sources 1.2 0.0'
              className: 'arrow-left'
              next: 'change select.sources': 'scatterplot3'
    scatterplot3: new Step
              header: 'Plotting data'
              details: "Now let's make our plot. Under <b>X-Axis</b>, select `r' (the magnitude)."
              attachment: 'left center select.axis.x-axis 1.2 0.0'
              className: 'arrow-left'
              next: 'change select.axis.x-axis': 'scatterplot4'
    scatterplot4: new Step
              header: 'Plotting data'
              details: "Under <b>Y-Axis</b>, select `color'."
              attachment: 'left center select.axis.y-axis 1.2 0.0'
              className: 'arrow-left'
              next: 'change select.axis.y-axis': 'scatterplot5'
    scatterplot5: new Step
              header: 'Plotting data'
              details: "Nice work - you've just made a color-magnitude diagram for your galaxies! This illustrates some of their basic properties: brighter galaxies tend to be redder (and mostly elliptical), while bluer galaxies are generally dimmer (and mostly spiral)."
              attachment: 'left center select.axis.y-axis 1.2 0.0'
              className: 'arrow-left'
              next: 'save1'
              nextButton: 'Done with Scatterplot'
    save1: new Step
              header: 'Saving data'
              details: "Finally, you might be interested in downloading your data so you can use it outside of zootools. In the SkyServer-1 window, click on the <b>Download Data</b> button and you can download your data as a CSV file."
              focus: 'container'
              next: 'click button.action.column.one-half' : 'finish'
    finish: new Step
              header: 'Finished'
              details: "Congratulations! You've selected some data from SkyServer, created new data columns, plotted the results, and learned how to download it to your computer.<br><br>Feel free to keep exploring and see everything else that Tools can do."
              nextButton: 'end'

