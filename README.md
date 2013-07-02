Ubret Dashboard
============

To build:

    npm install .
    brunch w -s

To use with dev.zooniverse.api

    npm start

## Adding a Tool to the Dashboard
After creating a tool using the [Ubret Library](https://github.com/zooniverse/Ubret), you'll probably want to be able to use it on the Dashboard. Luckily, the process is very simple. 

### Step 1 - Update the Project
Open `app/config/project_config.coffee` in your favourite text editor and make sure that the project you're targeting exists. If not add it! If the project does exist add your tool's name to the project's tool array. 

### Step 2 - Add Tool Configuration
Open `app/config/tool_config.coffee` and add any configuration your tool needs to it. The only required field is settings, where you should generally at least have an array containing `settings.data` which allow you to connect your tool to others. You can have the following fields in your configuration. 

* `settings` - An Array of setting views that will be available to control the tool. 
* `defaults` - An Object of the default settings for your tool. Properties here will be available as fields of the `@opts` object in your tool. 
* `titleBarControls` - Gives you controls in the title bar of the tool's window that trigger the `next` and `prev` events. 
* `locked` - Prevents the user from resizing the tool. 
* `height` - Sets the default height of the window. 
* `width` - Set the default width of the window
* `data_source` - Specifies defaults for a tool's data source. 

### Step 3 - Refreash the Page!
