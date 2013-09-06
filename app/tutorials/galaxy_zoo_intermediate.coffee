{Step} = zootorial

module.exports = new zootorial.Tutorial 
  id: 'galaxy_zoo_intermediate_tutorial'
  firstStep: 'welcome'
  steps:
    welcome: new Step
      header: "Welcome to zootools!"
      details: "zootools is a website designed to let you explore data from our citizen science projects. This short tutorial will demonstrate some more features for the site using data from Galaxy Zoo."
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
              details: "For Galaxy Zoo, you can either select data classified by Galaxy Zoo (<b>Zooniverse</b>) or load external data from the Sloan Digital Sky Survey (<b>Skyserver</b>).<br><br>For now, let’s select <b>Zooniverse</b>."
              attachment: 'left top a[data-tool="Zooniverse"] 0.0 3.0'
              #className: 'arrow-top'
              next: 'click li a[data-tool="Zooniverse"]': 'data3'
    data3: new Step
              header: 'Loading Data'
              details: "From Zooniverse, choose a set of galaxies you'd like to import. Try selecting <b>Collections</b> -- you can either select a collection of your own, or enter the name of someone else's (for example, CGZL00001w).<br><br>Once you've selected a collection, click on <b>Import Data</b>."
              attachment: 'center bottom a[data-target="recents"] center -2.0'
              className: 'arrow-bottom'
              next: 'click button.import': 'table1'
    table1: new Step
              header: 'Examining Data'
              details: "Great - you've imported the data to your Dashboard! Let’s use the Table tool to take a look at the dataset.<br><br>First, switch from Data to the <b>Tools</b> tab, then select <b>Table</b>."
              attachment: 'left top a[data-drawer="tool"] 0.0 3.5'
              next: 'click a[data-tool="Table"]': 'table2'
    table2: new Step
              header: 'Table'
              details: "To use the Table, we need to connect it to the data. In the <b>Data Source</b> menu, choose the data set you just imported (which should be named `Zooniverse-1')."
              attachment: 'left center select.sources 1.2 0.0'
              className: 'arrow-left'
              next: 'change select.sources': 'table3'
    table3: new Step
              header: 'Table'
              details: "Your collection is now connected to the <b>Table</b> tool. <b>Table</b> lets you view all the numerical data associated with each galaxy, similar to a spreadsheet.<br><br>Scroll to the right in the Table and click on the top of the column named <b>r</b> to sort the data by its r-band magnitude."
              attachment: 'left top button.previous center 0.6'
              #next: 'click th a[data-key="redshift"]':'table4'
              nextButton: 'Next'
              next: 'table4'
    table4: new Step
              header: 'Table'
              details: "You can browse through the data by scrolling left and right to see the various columns. Try sorting on different columns to see what ranges you have for the data in your collection."
              attachment: 'left top button.previous center 0.6'
              className: 'arrow-left'
              nextButton: 'Finished with Table'
              next: 'histogram1'
    histogram1: new Step
              header: 'Histogram'
              details: "Now that you've looked through the raw data, let's analyze some of it. We're going to create a graph showing the distribution of the magnitudes of the galaxies in your collection.<br><br>Start by selecting <b>Histogram</b> from under the Tools tab."
              attachment: 'center top a[data-drawer="data"] center 4.5'
              className: 'arrow-top'
              next: 'click a[data-tool="Histogram"]': 'histogram2'
    histogram2: new Step
              header: 'Histogram'
              details: "Connect your dataset to the Histogram tool by selecting `Zooniverse-1' under the <b>Data Source</b> menu."
              attachment: 'left center select.sources 1.2 0.0'
              className: 'arrow-left'
              next: 'change select.sources': 'histogram3'
    histogram3: new Step
              header: 'Histogram'
              details: "Now select <b>r</b> as the x-axis variable."
              attachment: 'left center select.axis 1.2 0.0'
              className: 'arrow-left'
              next: 'change select.axis' : 'histogram4'
    histogram4: new Step
              header: 'Histogram'
              details: "This shows the distribution of r-band magnitudes for your collection. You can change the plot range by entering numbers in <b>X-Min</b> and <b>X-Max</b>, or change the width of the bins using the slider at the bottom.<br><br>Click on the <b>&#5586;</b> in the menu bar to see the full plot."
              attachment: 'left center select.axis 1.2 center'
              className: 'arrow-left'
              nextButton: 'Done with Histogram'
              next: 'stats1'
    stats1: new Step
              header: 'Statistics'
              details: "While the visual representation in Histogram is useful, we can add to our analysis by computing some numbers for this dataset.<br><br>Let's select <b>Statistics</b> from under the Tools tab."
              attachment: 'center top a[data-drawer="data"] center 4.5'
              className: 'arrow-top'
              next: 'click a[data-tool="Statistics"]': 'stats2'
    stats2: new Step
              header: 'Statistics'
              details: "Connect the dataset to the Statistics tool by selecting `Zooniverse-1' under the <b>Data Source</b> menu."
              attachment: 'left center select.sources 1.2 0.0'
              className: 'arrow-left'
              next: 'change select.sources': 'stats3'
    stats3: new Step
              header: 'Statistics'
              details: "Let's find the median r-band magnitude of these galaxies. Select the 'r' field from this menu; the median value (as well as many other statistics) appears to the left.<br><br>Does the median value fall near the peak of the distribution in your <b>Histogram</b> plot?"
              attachment: 'left center select.select-key 1.2 0.0'
              className: 'arrow-left'
              next: 'change select.select-key' : 'finish'
    save1: new Step
              header: 'Save'
              details: "Attach this when there's an option to save a plot."
              next: 'finish'
    finish: new Step
              header: 'Finished'
              details: "Congratulations! You've selected some data, examined it and plotted it on a map, and learned how to share it with others.<br><br>Feel free to keep exploring and see everything else that Tools can do."
              nextButton: 'end'
