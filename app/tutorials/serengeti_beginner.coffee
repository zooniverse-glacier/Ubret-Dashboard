{Step} = zootorial

module.exports = new zootorial.Tutorial 
  id: 'serengeti_beginner_tutorial'
  firstStep: 'welcome'
  steps:
    welcome: new Step
      header: "Welcome to zootools!"
      details: "zootools is a website designed to let you explore data from our citizen science projects. This short tutorial will demonstrate some features using data from Snapshot Serengeti."
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
              details: "For Snapshot Serengeti, you can either explore the basic image data shown to users on the main site (<b>Zooniverse</b>) or dive deeper into the classifications users have already made (<b>Snapshot Serengeti</b>).<br><br>For now, let’s select <b>Zooniverse</b>."
              attachment: 'left top a[data-tool="Zooniverse"] 0.0 3.0'
              #className: 'arrow-top'
              next: 'click li a[data-tool="Zooniverse"]': 'data3'
    data3: new Step
              header: 'Loading Data'
              details: "From Zooniverse, choose a set of images you'd like to import. Try selecting <b>Recents</b> -- this searches for images you've recently classified in Snapshot Serengeti."
              attachment: 'center bottom a[data-target="recents"] center -2.0'
              className: 'arrow-bottom'
              next:
                  'click a[data-target="recents"]': 'data4'
                  'click a[data-target="favorites"]': 'data4'
    data4: new Step
              header: 'Loading Data'
              details: "Move the slider around to select the number of images, then click on <b>Import Data</b>."
              attachment: 'center top button.import center 2.0'
              className: 'arrow-top'
              next: 'click button.import': 'tools1'
    tools1: new Step
              header: 'Examining Data'
              details: "Great - you've imported data to your Dashboard! Let’s use the Subject Viewer tool to take a look at it.<br><br>First, switch from Data to the <b>Tools</b> tab, then select <b>Subject Viewer</b>."
              attachment: 'left top a[data-drawer="tool"] 0.0 3.5'
              next: 'click a[data-tool="SubjectViewer"]': 'tools2'
    tools2: new Step
              header: 'Subject Viewer'
              details: "To use this tool, we need to connect it to the data. In the <b>Data Source</b> menu, choose the data set you just imported (which should be named `Zooniverse-1')."
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
              details: "You can also use zootools to view larger images of your animals. Select the <b>Image Gallery</b> tool from under the <b>Tools</b> tab."
              attachment: 'center top a[data-drawer="data"] center 4.5'
              className: 'arrow-top'
              next: 'click a[data-tool="ImageGallery"]': 'gallery2'
    gallery2: new Step
              header: 'Image Gallery'
              details: "Connect your dataset to the new tool by selecting `Zooniverse-1' under the <b>Data Source</b> menu."
              attachment: 'left center select.sources 1.2 0.0'
              className: 'arrow-left'
              next: 'change select.sources': 'gallery3'
    gallery3: new Step
              header: 'Image Gallery'
              details: "Images from your dataset are now shown as thumbnails across the top of <b>Image Gallery</b>. Click on any of them to bring up a larger version. <br><br>Click on the <b>&#5586;</b> in the menu bar to see the full image more clearly, and browse by using <b>&lt;</b> and <b>&gt;</b> or the `Previous'/`Next' buttons."
              attachment: 'left center select.sources 1.2 0.0'
              nextButton: 'Finished with the Image Viewer'
              next: 'share1'
    share1: new Step
              header: 'Sharing Data'
              details: "You've explored several ways to view and interact with the data. Now let's look at how you can share your results with other people.<br><br>First, click on <b>Dashboards</b> to look at all the Dashboard areas you've created so far."
              attachment: 'center top a.my-dashboards center bottom'
              className: 'arrow-top'
              next: 'click a.my-dashboards': 'share15'
    share15: new Step
              header: 'Sharing Data'
              attachment: 'center top a.my-dashboards center bottom'
              next: 'share2'
    share2: new Step
              header: 'Sharing Data'
              details: "Click on `Share'."
              attachment: 'center top .share center 2.0'
              className: 'arrow-top'
              next: 'click .share': 'share3'
    share3: new Step
              header: 'Sharing Data'
              details: "To share your Dashboard, you can either use the <b>url</b> (which can access the Dashboard from any browser), or share it through <b>Twitter</b> or <b>Facebook</b>."
              attachment: 'left center .facebook 1.5 center'
              className: 'arrow-left'
              next: 'click .url': 'finish'
    finish: new Step
              header: 'Finished'
              details: "Congratulations! You've selected some data, examined the images and associated metadata, and learned how to share it with others.<br><br>Feel free to keep exploring and see everything else that Tools can do."
              nextButton: 'Done'
