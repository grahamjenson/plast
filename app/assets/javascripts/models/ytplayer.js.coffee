class Plast.Models.YTPlayer extends Backbone.RelationalModel
  #this is a wrapper around the

  initialize: ->
    this.set("state", Plast.Models.YTPlayer.UNSTARTED)

    window.onYouTubePlayerReady = (id) =>
      console.log("YTPlayer loaded")
      ytplayer.addEventListener("onStateChange", "youtubePlayerStateChange");
      this.timer = setInterval( =>
        p = ytplayer.getCurrentTime()/ytplayer.getDuration()
        this.set("progress", p*100)
      ,1000)

      this.set("state", Plast.Models.YTPlayer.READY)


      #@ytplayer = $("#"+"#{id}")[0] #this is so slow
    window.youtubePlayerStateChange = (state) =>
      this.set("state",state)

  embedYTPlayer: ->
    swfobject.embedSWF("http://www.youtube.com/v/oHg5SJYRHA0?version=3&enablejsapi=1&playerapiid=ytplayer&fs=1",
      "ytplayer",
      "600",
      "400",
      "9.0.0",
      null,
      null,
      { allowScriptAccess: "always", allowfullscreen: "true", wmode: "opaque"},
      { id: "ytplayer" })



Plast.Models.YTPlayer.UNSTARTED = -1# (unstarted)
Plast.Models.YTPlayer.ENDED = 0 #(ended)
Plast.Models.YTPlayer.PLAYING = 1# (playing)
Plast.Models.YTPlayer.PAUSED = 2# (paused)
Plast.Models.YTPlayer.BUF = 3 #(buffering)
Plast.Models.YTPlayer.CUED = 5 #(video cued).
Plast.Models.YTPlayer.READY = 6 #ready
