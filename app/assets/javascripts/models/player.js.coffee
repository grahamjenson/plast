class Plast.Models.Player extends Backbone.RelationalModel
  urlRoot: "/api/playlists"

  #my own version of the youtube player
  relations: [{
      type: Backbone.HasOne,
      key: 'playlist',
      relatedModel: 'Plast.Models.Playlist',
      reverseRelation:
        key: 'player',
      },
      {
      type: Backbone.HasOne,
      key: 'ytplayer',
      relatedModel: 'Plast.Models.YTPlayer',
      reverseRelation:
        key: 'player',
      },
      {
      type: Backbone.HasOne,
      key: 'scplayer',
      relatedModel: 'Plast.Models.SCPlayer',
      reverseRelation:
        key: 'player',
      }
    ]


  all_players: -> [@get('ytplayer'),@get('scplayer')]

  get_player: (plitem) ->
    playername = plitem.get('playername')
    if playername == 'youtube'
      return @get('ytplayer')
    if playername == 'soundcloud'
      return @get('scplayer')

  initialize: ->
    this.set("repeat", true)
    this.set("state", Plast.Models.Player.STATE_NOTREADY)

    this.get("ytplayer").bind("change:state", (model,state) =>
      switch state
        when Plast.Models.YTPlayer.READY then this.set("state", Plast.Models.Player.STATE_READY)
        when Plast.Models.YTPlayer.UNSTARTED then #do nothing
        when Plast.Models.YTPlayer.ENDED then this.playNext()
        when Plast.Models.YTPlayer.PLAYING then this.set("state",Plast.Models.Player.STATE_PLAYING)
        when Plast.Models.YTPlayer.PAUSED then this.set("state",Plast.Models.Player.STATE_PAUSED)
        when Plast.Models.YTPlayer.BUF then #do nothgin
        when Plast.Models.YTPlayer.CUED then #do nothing
    )
    this.get("ytplayer").bind("change:progress", (model,progress) => this.set("progress",progress))

    this.get("scplayer").bind("change:state", (model,state) =>
      switch state
        when SC.Widget.Events.READY then #do nothing this is faster than youtube #TODO make ready take into account all players
        when SC.Widget.Events.PLAY then this.set("state",Plast.Models.Player.STATE_PLAYING)
        when SC.Widget.Events.PAUSE then this.set("state",Plast.Models.Player.STATE_PAUSED)
        when SC.Widget.Events.FINISH then this.playNext()
    )

    this.get("scplayer").bind("change:progress", (model,progress) => this.set("progress",progress))

    #@bind("change:currentplayer", (model,player) => (p.get_player_element().hide() for p in @all_players() when p != player))

  skipToItem: (plitem) ->
    this.get("playlist").makeAllPlayable()
    for pli in this.get("playlist").getPlayableItems()
      console.log(pli)
      if pli == plitem
        break
      else
        console.log("set played")
        pli.set("played", (new Date()).getTime())
    this.playItem(plitem)

  playItem: (plitem) ->
    currentplayer = @get('currentplayer')
    if currentplayer
      currentplayer.unload()
      currentplayer.hide()

    plitem.set("played", (new Date()).getTime())
    this.playingitem = plitem

    console.log("Playing #{plitem.get('title')}")
    newplayer = @get_player(plitem)
    newplayer.show()
    @set('currentplayer', newplayer)

    newplayer.load_and_play_plitem(plitem)
    this.set("playing", plitem)

  playNext: (plitem = null) ->
    if not plitem
      plitem = this.get("playlist").getPlayableItems()[0]
      if not plitem
        console.log("End of List")
        this.get("playlist").makeAllPlayable()
        if not this.get("repeat")
          console.log("stopping playing")
          return
        else
          plitem = this.get("playlist").getPlayableItems()[0]

    this.playItem(plitem)


  back: ->
    this.playingitem.set("played", false)
    plitem = this.get("playlist").getLastPlayed()
    this.playNext(plitem)
    console.log("back")

  pause: ->
    console.log("pause")
    @get('currentplayer').pause()

  play: ->
    switch this.get("state")
      when Plast.Models.Player.STATE_NOTREADY then #do nothing
      when Plast.Models.Player.STATE_READY then this.playNext()
      when Plast.Models.Player.STATE_PLAYING then #do nothing
      when Plast.Models.Player.STATE_PAUSED then this.resumeplaying()

  resumeplaying: ->
    @get('currentplayer').play()

  forward: ->
    this.playNext()

  fullscreen: ->
    @get('currentplayer').fullscreen()

Plast.Models.Player.STATE_NOTREADY = 0
Plast.Models.Player.STATE_READY = 1
Plast.Models.Player.STATE_PLAYING = 2
Plast.Models.Player.STATE_PAUSED = 3
