{Step} = zootorial

module.exports = new zootorial.Tutorial 
  id: 'serengeti_advanced_tutorial'
  firstStep: 'welcome'
  steps:
    welcome: new Step
      header: "Welcome to zootools!"
      details: "zootools is a website designed to let you explore data from our citizen science projects. This short tutorial will demonstrate some advanced features for the site using data from Snapshot Serengeti."
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
              details: "For Snapshot Serengeti, you can either explore the basic image data shown to users on the main site (<b>Zooniverse</b>) or dive deeper into the classifications users have already made (<b>Snapshot Serengeti</b>).<br><br>Let’s select <b>Snapshot Serengeti</b> to explore the user classifications."
              attachment: 'left top a[data-tool="Snapshot Serengeti"] 0.0 3.0'
              #className: 'arrow-top'
              next: 'click li a[data-tool="Snapshot Serengeti"]': 'data3'
    data3: new Step
              header: 'Loading Data'
              details: "Under <b>Search Types</b>, select `Filter'."
              attachment: 'center bottom select.search_types center -2.0'
              className: 'arrow-bottom'
              next: 'change select.search_types' : 'data4'
    data4: new Step
              header: 'Loading Data'
              details: "The menus allow you to select data based on the consensus classifications by users that have already been done. Let's examine images of wildebeests eating: select `wildebeest' under the <b>Species</b> menu and `eating' under <b>Behavior</b>.<br><br>Click <b>Load Data</b> to finish your selection."
              attachment: 'center left button.action.load center right'
              className: 'arrow-top'
              #next: 'click button.action.load': 'tools1'
              next: 'tools1'
              nextButton: 'Next'
    tools1: new Step
              header: 'Examining Data'
              details: "Great - you've imported the data. Let’s check to see that the selection worked as expected.<br><br>First, switch from Data to the <b>Tools</b> tab, then select <b>Subject Viewer</b>."
              attachment: 'left top a[data-drawer="tool"] 0.0 3.5'
              next: 'click a[data-tool="SubjectViewer"]': 'tools2'
    tools2: new Step
              header: 'Subject Viewer'
              details: "To use this tool, we need to connect it to the data. In the <b>Data Source</b> menu, choose the data set you just imported (which should be named `Snapshot Serengeti-1')."
              attachment: 'left center select.sources 1.2 0.0'
              className: 'arrow-left'
              next: 'change select.sources': 'tools3'
    tools3: new Step
              header: 'Subject Viewer'
              details: "The data and tool are now connected! <b>Subject Viewer</b> lets you browse the data associated with each image, including the location of the image, the time it was taken, and animal species identified.<br><br>Click on the <b>&#5586;</b> in the menu bar to see the image more clearly."
              attachment: 'left top button.previous center 0.6'
              next: 'click div.toggle':'tools4'
    tools4: new Step
              header: 'Subject Viewer'
              details: "You can browse through images in this dataset by using the <b>&lt;</b> and <b>&gt;</b> symbols in the top bar."
              attachment: 'left top button.previous center 0.6'
              next: 'gallery1'
              nextButton: 'Continue'
    gallery1: new Step
              header: 'Image Gallery'
              details: "Let's examine the details of this dataset. Select the <b>Bar Graph</b> tool from under the <b>Tools</b> tab."
              attachment: 'center top a[data-drawer="data"] center 4.5'
              className: 'arrow-top'
              next: 'click a[data-tool="BarGraph"]': 'gallery2'
    gallery2: new Step
              header: 'Image Gallery'
              details: "Connect your dataset to the new tool by selecting `Snapshot Serengeti-1' under the <b>Data Source</b> menu."
              attachment: 'left center select.sources 1.2 0.0'
              className: 'arrow-left'
              next: 'change select.sources': 'gallery3'
    gallery3: new Step
              header: 'Image Gallery'
              details: "Let's see what other animals are around wildebeest while they're busy eating. Select `Species' under the menu <b>X-Axis</b>."
              attachment: 'left center select.axis.x-axis 1.2 0.0'
              next: 'change select.axis.x-axis' : 'gallery4'
    gallery4: new Step
              header: 'Image Gallery'
              details: "The <b>Bar Graph</b> shows the number of associated species in this picture; which species is the next-most common behind wildebeest?<br><br>You can also look at other data, like `counts' (what's the typical size of a group of wildebeest eating?) or `behaviors' (what else are the wildebeest doing while they're eating?)."
              attachment: 'left center select.axis.x-axis 1.2 0.0'
              next: 'finish'
              nextButton: 'Done'
    # When possible, add steps for saving an image
    finish: new Step
              header: 'Finished'
              details: "Congratulations! You've started to explore the classification data from Snapshot Serengeti.<br><br>Feel free to keep exploring and see everything else that Tools can do."
              nextButton: 'Done'
