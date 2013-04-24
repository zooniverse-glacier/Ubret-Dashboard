module.exports = [
  id: 1
  name: 'Zooniverse'
  search_types: [
    name: "Id"
    url: (id) -> "/subjects/#{id}"
    params:
      id:
        type: "Input"
        require: true
        validation: ""
  ,
    name: "Recents"
    url: (userId) -> "/users/#{userId}/recents"
    params:
      limit:
        type: "Input"
        require: true
        validation: ""
  ,
    name: 'Favorites' 
    url: (userId) -> "/users/#{userId}/favorites"
    params:
      limit:
        type: "Input"
        require: true
        validation: ""
  ,
    name: 'Talk Collections'
    url: (id) -> "/talk/collections/#{id}"
    params:
      id:
        type: "Input"
        require: true
        validation: ""
  ]
,
  id: 2
  name: 'Sky Server'
  url: '/sky_server'
  search_types: [
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
   ,
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
  ,
    name: 'sql'
    params:
      query:
        type: "Textbox"
        placeholder: "Enter SQL query"
  ]
,
  id : 3
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
]