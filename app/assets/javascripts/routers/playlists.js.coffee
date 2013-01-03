class Plast.Routers.Playlists extends Backbone.Router
  routes:
    '': 'newpl'
    'playlist/:uuid' : 'showpl'
    'p/:id' : 'readonlypl'

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
      @navigate("playlist/#{npl.get('id')}",{replace: true, trigger: true});
    error:(error) =>
      console.log(error)
      })

  readonlypl: (id) ->
    npl = new Plast.Models.Playlist({id: id, readonly: true})
    window.global_pl = npl
    npl.fetch({success: =>
      #create and render ytPlayer
      #models
      ytplayer = new Plast.Models.YTPlayer()
      player = new Plast.Models.Player({ytplayer: ytplayer, playlist: npl})

      #views
      console.log("rendering readonly views")
      plview = new Plast.Views.Playlist({el: $('#playlist'), model : npl, attributes: {player: player}})
      playerhead = new Plast.Views.PlayerHead({el : $('#playerhead'), model: player})
      youtubeplayerview = new Plast.Views.YoutubePlayer({model: ytplayer})
      full_side_bar = new Plast.Views.FullSideBar({model: npl, el: $('#js-right-side-bar')})
    })

  renderpl: (pl) ->
    window.global_pl = pl
    pl.fetch({success: =>
      #create and render ytPlayer
      #models
      ytplayer = new Plast.Models.YTPlayer()
      scplayer = new Plast.Models.SCPlayer()
      player = new Plast.Models.Player({ytplayer: ytplayer, scplayer: scplayer, playlist: pl})

      #views
      console.log("rendering views")
      plview = new Plast.Views.Playlist({el: $('#playlist'), model : pl, attributes: {player: player}})
      plsearch = new Plast.Views.Search({el: $('#search'), model : pl})
      playerhead = new Plast.Views.PlayerHead({el : $('#playerhead'), model: player})
      youtubeplayerview = new Plast.Views.YoutubePlayer({model: ytplayer})
      help_view = new Plast.Views.HelpContainer({el: $('.wrapper')})
      full_side_bar = new Plast.Views.FullSideBar({model: pl, el: $('#js-right-side-bar')})

    })
