class Plast.Routers.Playlists extends Backbone.Router
  routes:
    '': 'index'
    'playlist/:uuid' : 'showpl'
    'playlist' : 'newpl'

  constructor: ->
    super()
    @jumbo = new Plast.Views.Jumbo()
    this.bind("all", (route, router) ->
      $('#jumbo').html(@jumbo.render().el))

  index: ->
    console.log("index")

  showpl: (uuid) ->
    console.log("Showpl Route")
    npl = new Plast.Models.Playlist({id : uuid})
    npl.fetch()
    plview = new Plast.Views.Playlist(npl)
    $('#playlist').html(plview.render().el)


  newpl: ->
    npl = new Plast.Models.Playlist()
    npl.save({},{
    success: =>
      @navigate("playlist/#{npl.get('id')}",{trigger: true, replace: true});
    error: =>
      @navigate("",{trigger: true});
      })


