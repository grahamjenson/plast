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
    youtubeplayerview = new Plast.Views.YoutubePlayer()
    $('#youtubeplayer').html(youtubeplayerview.render().el)

    player = new Plast.Models.Player()
    player.set("playlist",pl)

    plview = new Plast.Views.Playlist(pl)

    plsearch = new Plast.Views.Search(pl)

    playerhead = new Plast.Views.PlayerHead(player)

    $('#playlist').html(plview.render().el)

    $('#search').html(plsearch.render().el)

    $('#playerhead').html(playerhead.render().el)

