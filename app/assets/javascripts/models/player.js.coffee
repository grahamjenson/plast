class Plast.Models.Player extends Backbone.RelationalModel
  urlRoot: "/api/playlists"

  relations: [{
      type: Backbone.HasOne,
      key: 'playlist',
      relatedModel: 'Plast.Models.Playlist',
      reverseRelation:
        key: 'player',
        includeInJSON: 'uuid'
      }]


  initialize: ->
    this.set("repeat", true)
    this.set("state", Plast.Models.Player.STATE_NOTREADY)
    window.onYouTubePlayerReady = (id) =>
      console.log("onYouTubePlayerResadsadsady() Fired! #{id}");
      this.set("state", Plast.Models.Player.STATE_READY)
      ytplayer.addEventListener("onStateChange", "youtubePlayerStateChange");
      this.timer = setInterval( =>
        p = ytplayer.getCurrentTime()/ytplayer.getDuration()
        this.set("progress", p*100)
      ,1000)

      #@ytplayer = $("#"+"#{id}")[0] #this is so slow
    window.youtubePlayerStateChange = (state) =>
      switch state
        when Plast.Models.Player.YTSTATE_UNSTARTED then #do nothing
        when Plast.Models.Player.YTSTATE_ENDED then this.playNext()
        when Plast.Models.Player.YTSTATE_PLAYING then this.set("state",Plast.Models.Player.STATE_PLAYING)
        when Plast.Models.Player.YTSTATE_PAUSED then this.set("state",Plast.Models.Player.STATE_PAUSED)
        when Plast.Models.Player.YTSTATE_BUF then #do nothgin
        when Plast.Models.Player.YTSTATE_CUED then #do nothing

    swfobject.embedSWF("http://www.youtube.com/v/oHg5SJYRHA0?version=3&enablejsapi=1&playerapiid=ytplayer&fs=1", "ytplayer", "600", "400", "9.0.0", null, null, { allowScriptAccess: "always", allowfullscreen: "true", wmode: "opaque"}, { id: "ytplayer" })

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
    ytplayer.loadVideoById(plitem.get("youtubeid"))

  back: ->
    this.playingitem.set("played", false)
    plitem = this.get("playlist").getLastPlayed()
    this.playNext(plitem)
    console.log("back")

  pause: ->
    console.log("pause")
    ytplayer.pauseVideo()

  play: ->
    switch this.get("state")
      when Plast.Models.Player.STATE_NOTREADY then #do nothing
      when Plast.Models.Player.STATE_READY then this.playNext()
      when Plast.Models.Player.STATE_PLAYING then #do nothing
      when Plast.Models.Player.STATE_PAUSED then this.resumeplaying()

  resumeplaying: ->
    ytplayer.playVideo()

  forward: ->
    this.playNext()


Plast.Models.Player.STATE_NOTREADY = 0
Plast.Models.Player.STATE_READY = 1
Plast.Models.Player.STATE_PLAYING = 2
Plast.Models.Player.STATE_PAUSED = 3

Plast.Models.Player.YTSTATE_UNSTARTED = -1# (unstarted)
Plast.Models.Player.YTSTATE_ENDED = 0 #(ended)
Plast.Models.Player.YTSTATE_PLAYING = 1# (playing)
Plast.Models.Player.YTSTATE_PAUSED = 2# (paused)
Plast.Models.Player.YTSTATE_BUF = 3 #(buffering)
Plast.Models.Player.YTSTATE_CUED = 5 #(video cued).
