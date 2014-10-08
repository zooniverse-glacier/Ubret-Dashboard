/* 
  A drop-in read-only Google-Spreadsheets-backed replacement for Backbone.sync

  Tabletop must be successfully initialized prior to using fetch()

  Backbone.tabletopSync only supports the 'read' method, and will fail
    loudly on any other operations
*/

Backbone.tabletopSync = function(method, model, options, error) {
  // Backwards compatibility with Backbone <= 0.3.3
  if (typeof options == 'function') {
    options = {
      success: options,
      error: error
    };
  }

  if (!options.deferred) {
      options.deferred =  new $.Deferred();
      options.deferred.done(options.success);
      options.deferred.fail(options.error);
  }

  var resp;

  var tabletopOptions = model.tabletop || model.collection.tabletop;

  var instance = tabletopOptions.instance;

  if(typeof(instance) == "undefined") {
    instance = Tabletop.init( { key: tabletopOptions.key,
                                wanted: [ tabletopOptions.sheet ],
                                wait: true } );
    tabletopOptions.instance = instance;
  } else {
    instance.addWanted(tabletopOptions.sheet);
  }
  
  if(typeof(tabletopOptions.sheet) == "undefined") {
    return;
  }
  
  var sheet = instance.sheets( tabletopOptions.sheet );

  if(typeof(sheet) === "undefined") {
    // Hasn't been fetched yet, let's fetch!
    
    // Let's make sure we aren't re-requesting a sheet that doesn't exist
    if(typeof(instance.foundSheetNames) !== 'undefined' && _.indexOf(instance.foundSheetNames, tabletopOptions.sheet) === -1) {
      throw("Can't seem to find sheet " + tabletopOptions.sheet);
    }

    instance.fetch( function() {
      Backbone.tabletopSync(method, model, options, error);
    });
    options.deferred.error = options.deferred.fail;
    return options.deferred;
  }

  switch (method) {
    case "read":
      if(model.id) {
        resp = _.find( sheet.all(), function(item) {
          return model.id == item[model.idAttribute];
        }, this);
      } else {
        resp = _.map(sheet.all(), function(item) {
          item.id = item.rowNumber;
          item.uid = item.rowNumber;
          delete item.rowNumber;
          return item;
        }, this);
      }
      break;
    default:
      throw("Backbone.tabletopSync is read-only");
  }

  if (resp) {
    options.deferred.resolve(resp);
  } else {
    options.deferred.reject();
  }
};
