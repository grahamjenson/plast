class Plast.Routers.Playlists extends Backbone.Router
  routes:
    '': 'index'
    'playlist/:uuid' : 'showpl'
    'playlist' : 'newpl'

  constructor: ->
    super()
    @jumbo = new Plast.Views.Jumbo(this)

  index: ->
    console.log("index")


  showpl: (uuid) ->
    npl = new Plast.Models.Playlist({id : uuid})
    @renderpl(npl)

  newpl: ->
    npl = new Plast.Models.Playlist()
    npl.save({},{
    success: =>
      @navigate("playlist/#{npl.get('id')}",{replace: true});
      @renderpl(npl)
    error: =>
      @navigate("",{trigger: true});
      })

  renderpl: (pl) ->
    pl.fetch()
    plview = new Plast.Views.Playlist(pl)
    $('#playlist').html(plview.render().el)



