class Plast.Models.YTPlayer extends Backbone.RelationalModel

  initialize: ->
    this.set("state", Plast.Models.YTPlayer.UNSTARTED)

    #get include the api script
    tag = document.createElement('script');
    tag.src = "//www.youtube.com/iframe_api";
    firstScriptTag = document.getElementsByTagName('script')[0];
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

    window.onYouTubeIframeAPIReady = () =>
      @youtubeplayerobject = new YT.Player('js-youtube-player', {
        align: "center",
        width: 200
        height: 200
        allowfullscreen: ""
        playerVars:
          allowfullscreen: true
          allowScriptAccess: 'always'
          controls: 0
          enablejsapi : 1,
          wmode : 'transparent',
          fs : 1,
          theme : 'light',
          modestbranding : 1,
        events: {
            'onReady': onPlayerReady,
            'onStateChange':  onPlayerStateChange
          }
        });

      window.globalytplayer = @youtubeplayerobject

    window.onPlayerReady = =>
      this.set("state", Plast.Models.YTPlayer.READY)
      this.timer = setInterval( =>
        p = @youtubeplayerobject.getCurrentTime()/@youtubeplayerobject.getDuration()
        this.set("progress", p*100)
      ,100)
      @setVolume(1)

      #@youtubeplayerobject = $("#"+"#{id}")[0] #this is so slow
    window.onPlayerStateChange = (event) =>
      state = event.data
      this.set("state",state)

  play: ->
    @youtubeplayerobject.playVideo()

  pause: ->
    @youtubeplayerobject.pauseVideo()

  unload: ->
    @youtubeplayerobject.loadVideoById("")

  load_and_play_plitem: (plitem) ->
    id = plitem.get("mediaid")
    @youtubeplayerobject.loadVideoById(id)

  setSize: (width = 640, height = 390) ->
    @youtubeplayerobject.setSize(width, height)

  height: ->
    $("#" + @youtubeplayerobject.a.id).height()

  width: ->
    $("#" + @youtubeplayerobject.a.id).width()

  hide: ->
    @get_player_element().hide()

  show: ->
    @get_player_element().show()

  get_player_element: -> $("#js-youtube-player")

  seekTo: (seconds) ->
    #seek is in seconds
    @youtubeplayerobject.seekTo(seconds)

  setVolume: (vol) ->
    #0 is nothing and 100 is full
    @youtubeplayerobject.setVolume(vol*100)

  fullscreen: ->
    fullScreenApi.requestFullScreen(document.getElementById("js-youtube-player"))

Plast.Models.YTPlayer.UNSTARTED = -1# (unstarted)
Plast.Models.YTPlayer.ENDED = 0 #(ended)
Plast.Models.YTPlayer.PLAYING = 1# (playing)
Plast.Models.YTPlayer.PAUSED = 2# (paused)
Plast.Models.YTPlayer.BUF = 3 #(buffering)
Plast.Models.YTPlayer.CUED = 5 #(video cued).
Plast.Models.YTPlayer.READY = 6 #ready
