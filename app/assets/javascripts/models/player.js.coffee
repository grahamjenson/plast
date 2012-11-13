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
      }]


  initialize: ->
    this.set("repeat", true)
    this.set("state", Plast.Models.Player.STATE_NOTREADY)
    this.set("playlist",pl)

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

    plitem.set("played", (new Date()).getTime())
    this.playingitem = plitem

    console.log("Playing #{plitem.get('title')}")
    this.get("ytplayer").loadVideo(plitem.get("youtubeid"))
    this.set("playing", plitem)

  back: ->
    this.playingitem.set("played", false)
    plitem = this.get("playlist").getLastPlayed()
    this.playNext(plitem)
    console.log("back")

  pause: ->
    console.log("pause")
    this.get("ytplayer").pauseVideo()

  play: ->
    switch this.get("state")
      when Plast.Models.Player.STATE_NOTREADY then #do nothing
      when Plast.Models.Player.STATE_READY then this.playNext()
      when Plast.Models.Player.STATE_PLAYING then #do nothing
      when Plast.Models.Player.STATE_PAUSED then this.resumeplaying()

  resumeplaying: ->
    this.get("ytplayer").playVideo()

  forward: ->
    this.playNext()


Plast.Models.Player.STATE_NOTREADY = 0
Plast.Models.Player.STATE_READY = 1
Plast.Models.Player.STATE_PLAYING = 2
Plast.Models.Player.STATE_PAUSED = 3

