class Plast.Models.SCPlayer extends Backbone.RelationalModel

  initialize: ->
    return
    this.set("state", Plast.Models.SCPlayer.UNSTARTED)

    #get include the api script
    $("#js-soundcloud-player").append('<iframe id="js-iscplayer" src="https://w.soundcloud.com/player/?url=http%3A%2F%2Fapi.soundcloud.com%2Ftracks%2F68083379" width="100%" height="166" scrolling="no" frameborder="no"></iframe>')
    @scplayer = SC.Widget(document.getElementById('js-iscplayer'));
    window.scplayer = @scplayer

  playVideo: ->
    @scplayer.play()
  pauseVideo: ->
    @scplayer.pause()

  loadVideo: (plitem) ->

  setSize: (width = 640, height = 390) ->

  height: ->
    return 166
  width: ->

Plast.Models.SCPlayer.UNSTARTED = -1# (unstarted)
Plast.Models.SCPlayer.ENDED = 0 #(ended)
Plast.Models.SCPlayer.PLAYING = 1# (playing)
Plast.Models.SCPlayer.PAUSED = 2# (paused)
Plast.Models.SCPlayer.BUF = 3 #(buffering)
Plast.Models.SCPlayer.CUED = 5 #(video cued).
Plast.Models.SCPlayer.READY = 6 #ready
