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
  
  serengeti_classifications:
    name: 'Snapshot Serengeti'
    url: 'https://the-zooniverse.cartodb.com/api/v2/sql'
    search_types:
      filter:
        name: 'Filter'
        builder: (opts) ->
          query = 'select * from serengeti '
          criteria = []
          unless opts.species is ''
            criteria.push "species @> '{ \"#{ opts.species }\" }'"
          
          unless opts.site is ''
            criteria.push "site = '#{ opts.site }'"
          
          unless opts.user_group is '' or opts.user_group is 'null'
            criteria.push "user_group_ids @> '{ \"#{ opts.user_group }\" }'"
          
          if criteria.length > 0
            query += 'where ' + criteria.join(' and ')
          
          query += ' order by captured_at limit 1000'
          
          encodeURI(query).replace(/\+/g, '%2B')
        params:
          species:
            type: 'Select'
            options: ['', 'aardvark', 'aardwolf', 'baboon', 'batearedfox', 'blank', 'buffalo', 'bushbuck', 'caracal', 'cheetah', 'civet', 'dikdik', 'eland', 'elephant', 'gazellegrants', 'gazellethomsons', 'genet', 'giraffe', 'guineafowl', 'hare', 'hartebeest', 'hippopotamus', 'honeybadger', 'human', 'hyenaspotted', 'hyenastriped', 'impala', 'jackal', 'koribustard', 'leopard', 'lionfemale', 'lionmale', 'mongoose', 'ostrich', 'otherbird', 'porcupine', 'reedbuck', 'reptiles', 'rhinoceros', 'rodents', 'secretarybird', 'serval', 'topi', 'vervetmonkey', 'warthog', 'waterbuck', 'wildcat', 'wildebeest', 'zebra', 'zorilla']
          site:
            type: 'Select'
            options: ['', 'B03', 'B04', 'B05', 'B06', 'B07', 'B08', 'B09', 'B10', 'B12', 'B13', 'C01', 'C02', 'C03', 'C04', 'C05', 'C06', 'C07', 'C08', 'C09', 'C10', 'C11', 'C12', 'C13', 'D02', 'D03', 'D04', 'D05', 'D06', 'D07', 'D08', 'D09', 'D10', 'D11', 'D12', 'D13', 'E01', 'E02', 'E03', 'E04', 'E05', 'E06', 'E07', 'E08', 'E09', 'E10', 'E11', 'E12', 'E13', 'F01', 'F02', 'F03', 'F04', 'F05', 'F06', 'F07', 'F08', 'F09', 'F10', 'F11', 'F12', 'F13', 'G01', 'G02', 'G03', 'G04', 'G05', 'G06', 'G07', 'G08', 'G09', 'G10', 'G11', 'G12', 'G13', 'H01', 'H02', 'H03', 'H04', 'H05', 'H06', 'H07', 'H08', 'H09', 'H10', 'H11', 'H12', 'H13', 'I01', 'I02', 'I03', 'I04', 'I05', 'I06', 'I07', 'I08', 'I09', 'I10', 'I11', 'I12', 'I13', 'J01', 'J02', 'J03', 'J04', 'J05', 'J06', 'J07', 'J08', 'J09', 'J10', 'J11', 'J12', 'J13', 'K01', 'K02', 'K03', 'K04', 'K05', 'K06', 'K07', 'K08', 'K09', 'K10', 'K11', 'K12', 'K13', 'L01', 'L02', 'L03', 'L04', 'L05', 'L06', 'L07', 'L08', 'L09', 'L10', 'L11', 'L12', 'L13', 'M01', 'M02', 'M03', 'M04', 'M05', 'M06', 'M07', 'M08', 'M09', 'M10', 'M11', 'M12', 'M13', 'N02', 'N03', 'N04', 'N05', 'N06', 'N07', 'N08', 'N09', 'N10', 'N11', 'N12', 'N13', 'O02', 'O03', 'O04', 'O05', 'O06', 'O07', 'O08', 'O09', 'O10', 'O11', 'O12', 'O13', 'P03', 'P04', 'P05', 'P06', 'P07', 'P08', 'P09', 'P10', 'P11', 'P12', 'P13', 'Q04', 'Q05', 'Q06', 'Q07', 'Q08', 'Q09', 'Q10', 'Q11', 'Q12', 'Q13', 'R05', 'R06', 'R07', 'R08', 'R09', 'R10', 'R11', 'R12', 'R13', 'S06', 'S07', 'S08', 'S09', 'S10', 'S11', 'S12', 'S13', 'T08', 'T09', 'T10', 'T11', 'T12', 'T13', 'U09', 'U10', 'U11', 'U12', 'U13', 'V10', 'V11', 'V12', 'V13', 'X11', 'X12', 'X13']
          user_group:
            type: 'Select'
            label: 'User Group'
            options: ->
              opts = { null: '' }
              groups = zooniverse.models.User.current.user_groups or []
              for group in groups
                opts[group.id] = group.name
              
              opts
  
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