class Plast.Routers.Playlists extends Backbone.Router
  routes:
    '': 'newel'
    'playlist/:uuid' : 'showpl'


  initialize: ->
    @bind 'all', @_trackPageview

  _trackPageview: ->
    url = Backbone.history.getFragment()
    _gaq.push(['_trackPageview', "/#{url}"])

  showpl: (uuid) ->
    console.log(uuid)
    npl = Plast.Models.Playlist.findOrCreate({id : uuid})
    @renderpl(npl)

  newpl: ->
    npl = new Plast.Models.Playlist()
    npl.save({},{
    success: =>
      @navigate("playlist/#{npl.get('id')}",{replace: true, trigger: false});
      @renderpl(npl)
    error: =>
      console.log(error)
      @navigate("");
      })

  renderpl: (pl) ->
    window.pl = pl
    pl.fetch({success: =>
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
    })
