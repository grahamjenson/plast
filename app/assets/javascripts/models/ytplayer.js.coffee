class Plast.Models.YTPlayer extends Backbone.RelationalModel
  #this is a wrapper around the youtube object
  #TODO replace swfobject with iframe https://developers.google.com/youtube/iframe_api_reference
  #Example http://www.andrewchart.co.uk/blog/web-design/youtube-chromeless-api-fullscreen
  initialize: ->
    this.set("state", Plast.Models.YTPlayer.UNSTARTED)

    #get include the api script
    tag = document.createElement('script');
    tag.src = "//www.youtube.com/iframe_api";
    firstScriptTag = document.getElementsByTagName('script')[0];
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

    window.onYouTubeIframeAPIReady = () =>
      console.log("API READY")
      @youtubeplayerobject = new YT.Player('youtubeplayer', {
        align: "center",
        playerVars:
          autoplay : 0,
          controls : 0,
          enablejsapi : 1,
          wmode : 'transparent',
          fs : 1,
          showinfo : 0,
          theme : 'light',
          modestbranding : 1,
        events: {
            'onReady': onPlayerReady,
            'onStateChange':  onPlayerStateChange
          }
        });

      window.globalytplayer = @youtubeplayerobject

    window.onPlayerReady = () =>
      console.log("YT RDY")
      console.log("YTPlayer loaded")
      this.set("state", Plast.Models.YTPlayer.READY)


      #@youtubeplayerobject = $("#"+"#{id}")[0] #this is so slow
    window.onPlayerStateChange = (event) =>
      state = event.data
      console.log("YT STATE CHANGE #{state}")
      this.set("state",state)

  embedYTPlayer: ->

    embeddedplayer = "v/oHg5SJYRHA0"
    chromelessplayer = "apiplayer"

    #swfobject.embedSWF("http://www.youtube.com/#{chromelessplayer}?version=3&enablejsapi=1&playerapiid=ytplayer&fs=1",
    #  "ytplayer",
    #  "600",
    #  "400",
    #  "9.0.0",
    #  null,
    #  null,
    #  { allowScriptAccess: "always", allowfullscreen: "true", wmode: "opaque"},
    #  { id: "globalYTPlayer" })



  playVideo: ->
    @youtubeplayerobject.playVideo()

  pauseVideo: ->
    @youtubeplayerobject.pauseVideo()

  loadVideo: (id) ->
    @youtubeplayerobject.loadVideoById(id)

  setSize: (width = 640, height = 390) ->
    @youtubeplayerobject.setSize(width, height)

  height: ->
    $("#" + @youtubeplayerobject.a.id).height()

  width: ->
    $("#" + @youtubeplayerobject.a.id).width()

Plast.Models.YTPlayer.UNSTARTED = -1# (unstarted)
Plast.Models.YTPlayer.ENDED = 0 #(ended)
Plast.Models.YTPlayer.PLAYING = 1# (playing)
Plast.Models.YTPlayer.PAUSED = 2# (paused)
Plast.Models.YTPlayer.BUF = 3 #(buffering)
Plast.Models.YTPlayer.CUED = 5 #(video cued).
Plast.Models.YTPlayer.READY = 6 #ready