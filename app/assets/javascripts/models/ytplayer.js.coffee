class Plast.Models.YTPlayer extends Backbone.RelationalModel
  #this is a wrapper around the youtube object
  #TODO replace swfobject with iframe https://developers.google.com/youtube/iframe_api_reference
  initialize: ->
    this.set("state", Plast.Models.YTPlayer.UNSTARTED)

    window.onYouTubePlayerReady = (id) =>
      @youtubeplayerobject = globalYTPlayer
      console.log("YTPlayer loaded")
      @youtubeplayerobject.addEventListener("onStateChange", "youtubePlayerStateChange");
      this.timer = setInterval( =>
        p = @youtubeplayerobject.getCurrentTime()/@youtubeplayerobject.getDuration()
        this.set("progress", p*100)
      ,1000)


      this.set("state", Plast.Models.YTPlayer.READY)


      #@youtubeplayerobject = $("#"+"#{id}")[0] #this is so slow
    window.youtubePlayerStateChange = (state) =>
      this.set("state",state)

  embedYTPlayer: ->

    embeddedplayer = "v/oHg5SJYRHA0"
    chromelessplayer = "apiplayer"

    swfobject.embedSWF("http://www.youtube.com/#{chromelessplayer}?version=3&enablejsapi=1&playerapiid=ytplayer&fs=1",
      "ytplayer",
      "600",
      "400",
      "9.0.0",
      null,
      null,
      { allowScriptAccess: "always", allowfullscreen: "true", wmode: "opaque"},
      { id: "globalYTPlayer" })



  playVideo: ->
    @youtubeplayerobject.playVideo()

  pauseVideo: ->
    @youtubeplayerobject.pauseVideo()

  loadVideo: (id) ->
    @youtubeplayerobject.loadVideoById(id)

Plast.Models.YTPlayer.UNSTARTED = -1# (unstarted)
Plast.Models.YTPlayer.ENDED = 0 #(ended)
Plast.Models.YTPlayer.PLAYING = 1# (playing)
Plast.Models.YTPlayer.PAUSED = 2# (paused)
Plast.Models.YTPlayer.BUF = 3 #(buffering)
Plast.Models.YTPlayer.CUED = 5 #(video cued).
Plast.Models.YTPlayer.READY = 6 #ready
