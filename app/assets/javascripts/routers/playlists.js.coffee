class Plast.Routers.Playlists extends Backbone.Router
  routes:
    '': 'index'
    'playlist/:uuid' : 'showpl'
    'playlist' : 'newpl'

  constructor: ->
    super()
    @jumbo = new Plast.Views.Jumbo(this)

  index: ->

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
    plsearch = new Plast.Views.Search(pl)
    plplayer = new Plast.Views.Player(pl)

    $('#playlist').html(plview.render().el)
    $('#search').html(plsearch.render().el)
    plplayer.render()

