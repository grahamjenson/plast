class Plast.Views.PlayerInfo extends Backbone.View

  template: JST['playlists/player_info']
  
  @disableupdate = false
  @qualityHigh = false

  events:
    'click #js-volumepb' : (e) -> @volumeclick(e)
    'click #js-quality-toggle': (e) -> @qualityToggle(e)

  seekclick: (e) ->
    percent = e.value/100
    progress = percent * 100
    $("#js-plitem-info-progress-bar").width("#{progress}%")

    playing = @player.get('playing')

    if playing
      seekToSec = playing.get('length')*percent
      @player.seekTo(seekToSec)

  qualityToggle: (e) ->
    @qualityHigh = not @qualityHigh
    if @qualityHigh
      $("#js-quality-toggle").addClass("active")
    else
      $("#js-quality-toggle").removeClass("active")

    @player.setQuality(@qualityHigh)

  volumeclick: (e) ->
    percent = e.offsetX / e.currentTarget.clientWidth
    @player.setVolume(percent)
    progress = 100 * percent
    $("#js-plitem-volume-bar").width("#{progress}%")


  initialize: ->
    @player = this.model


    @player.bind("change:progress", (model,progress) =>
      this.updateProgressBar(progress)
    )

    @player.bind("change:playing", (model,progress) =>
      #update title
      playing = @player.get("playing")
      $("#js-plitem-title").text(playing.get("title"))
    )

    this.render()



  render: ->
    $(@el).html(@template())
    $("#js-seek-clickable").slider(
      change: ( e, ui ) => @seekclick(ui)
      slide: ( e, ui ) => @seekclick(ui)
      start: (e, ui) =>  @disableupdate = true
      stop: (e,ui) =>  @disableupdate = false
    )
    this

  updateProgressBar: (progress) ->
    if not @disableupdate
      if (progress == 0 or isNaN(progress))
        progress = 0

      playing = @player.get("playing")

      if playing
        fb = playing.get("length")*(progress/100)
        fe = playing.get("length") - playing.get("length")*(progress/100)
        $("#js-plitem-from-begining").html(fb.toMinSec())
        $("#js-plitem-from-end").html("-#{fe.toMinSec()}")

      $(".ui-slider-handle").css("left", "#{progress}%")
      $("#js-plitem-info-progress-bar").width("#{progress}%")



