module.exports =
  zooniverse:
    name: 'Zooniverse'
    search_types: 
      id:
        name: "Id"
        url: (id) -> "/subjects/#{id}"
      recent:
        url: (userId) -> "/users/#{userId}/recents"
        auth: true
      favorite:
        url: (userId) -> "/users/#{userId}/favorites"
        auth: true
      collection:
        url: (id) -> "/talk/collections/#{id}"
  serengeti_carto:
    name: "Snapshot Serengeti CartoDB"
    url: "https://aliburchard.cartodb.com"
    search_types:
      species:
        name: 'species'
        builder: (i) ->
        params:
          species:
            type: 'Select'
            options: []
            required: true
      site:
        name: 'site'
        builder: (i) ->
        params:
          species:
            type: 'Select'
            options: []
            required: true
      both:
        name: 'both'
        builder: (i) ->
        params:
          species:
            type: 'Select'
          site:
            type: 'Select'
  
  sky_server:
    name: 'Sky Server'
    url: 'http://spelunker.herokuapp.com/sky_server'
    search_types:
      area:
        name: 'area'
        params:
          ra:
            type: "Range"
            required: true
            validation: [130, 260]
            label: 'RA'
          dec: 
            type: "Range"
            required: true
            validation: [-2, 60]
          radius: 
            type: "Input"
            required: true
            validation: ""
            placeholder: 'arcmin'
          limit: 
            type: "Input"
            required: false
            validation: ""
          spec:
            type: "Checkbox"
            required: false
            validation: ""
      bands:
        name: 'bands'
        params: 
          u: 
            type: 'Input'
            required: false
            validation: ""
            label: 'u'
          g: 
            type: 'Input'
            required: false
            validation: ""
            label: 'g'
          r: 
            type: 'Input'
            required: false
            validation: ""
            label: 'r'
          i: 
            type: 'Input'
            required: false
            validation: ""
            label: 'i'
          z: 
            type: 'Input'
            required: false
            validation: ""
            label: 'z'
          tolerance: 
            type: 'Input'
            required: true
            validation: [0, 5]
          limit: 
            type: "Input"
            required: false
            validation: ""
          spec:
            type: "Checkbox"
            required: false
            validation: ""
      sql:
        name: 'sql'
        params:
          query:
            type: "Textbox"
            required: true
            placeholder: "Enter SQL query"
  ned:
    name: 'NED'
    url: 'http://spelunker.herokuapp.com/ned'
    search_types: [
      name: 'area'
      params:
        ra:
          type: 'Range'
          required: true
          validation: [0, 360]
          label: 'RA'
        dec:
          type: 'Range'
          required: true
          validation: [-90, 90]
        radius:
          type: 'Input'
          required: true
          validation: ""
          placeholder: 'arcmin'
    ]