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
  sky_server:
    name: 'Sky Server'
    url: '/sky_server'
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
            required: false
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
            placeholder: "Enter SQL query"
  ned:
    name: 'NED'
    url: '/ned'
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