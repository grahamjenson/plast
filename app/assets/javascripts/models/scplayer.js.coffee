class Plast.Models.SCPlayer extends Backbone.RelationalModel

  initialize: ->
    this.set("state", Plast.Models.Player.STATE_NOTREADY)

    #get include the api script
    $("#js-soundcloud-player").append('<iframe id="js-iscplayer" src="https://w.soundcloud.com/player/?url=http%3A%2F%2Fapi.soundcloud.com%2Ftracks%2F68083379" width="320" height="60" scrolling="no" frameborder="no"></iframe>')
    @scplayer = SC.Widget(document.getElementById('js-iscplayer'));
    window.scplayer = @scplayer

    scplayer.bind(SC.Widget.Events.READY, =>
      this.set("state", SC.Widget.Events.READY)
    )

    scplayer.bind(SC.Widget.Events.PLAY, =>
      this.set("state", SC.Widget.Events.PLAY)
    )
    scplayer.bind(SC.Widget.Events.PAUSE, =>
      this.set("state", SC.Widget.Events.PAUSE)
    )
    scplayer.bind(SC.Widget.Events.FINISH, =>
      this.set("state", SC.Widget.Events.FINISH)
    )

    scplayer.bind(SC.Widget.Events.PLAY_PROGRESS, (e) =>
      this.set("progress", e.relativePosition*100)
    )

    $("#js-soundcloud-player").parent().append("<img id='js-soundcloud-player-thumbnail' height='200px' width='200px' style='display: none;'></img>")

  play: ->
    @scplayer.play()

  pause: ->
    @scplayer.pause()

  unload: ->
    @scplayer.load("https://api.sndcdn.com/tracks/-1",{})

  load_and_play_plitem: (plitem) ->
    $("#js-soundcloud-player-thumbnail").attr("src","#{plitem.get('thumbnail')}")
    @scplayer.load(plitem.get('mediaid'),
      {
        callback: =>
          @scplayer.play()
      }
    )

  get_player_element: -> $("#js-soundcloud-player")

  setSize: (width = 640, height = 390) ->

  hide: ->
    $("#js-soundcloud-player-thumbnail").hide()

  show: ->
    $("#js-soundcloud-player-thumbnail").show()

  height: ->
  width: ->
