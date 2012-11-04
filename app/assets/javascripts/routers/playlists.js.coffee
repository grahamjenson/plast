class Plast.Routers.Playlists extends Backbone.Router
  routes:
    '': 'newpl'
    'playlist/:uuid' : 'showpl'

  constructor: ->
    super()

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
      console.log(error)
      @navigate("");
      })

  renderpl: (pl) ->
    pl.fetch()
    plview = new Plast.Views.Playlist(pl)
    plsearch = new Plast.Views.Search(pl)
    plplayer = new Plast.Views.Player(pl)

    $('#playlist').html(plview.render().el)
    $('#search').html(plsearch.render().el)
    $('#playerhead').html(plplayer.render().el)

