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
        validation: [0, 360]
        label: 'RA'
      dec: 
        type: "Range"
        required: true
        validation: [-11, 40]
      radius: 
        type: "Input"
        required: true
        validation: ""
        placeholder: 'arcmin'
      limit: 
        type: "Input"
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
  ]
]