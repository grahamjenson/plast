class Plast.Views.PlitemInfoView extends Backbone.View

  events:
    'click #js-seekpb' : (e) -> @seekclick(e)

  template: JST['playlists/plitem_info']


  seekclick: (e) ->
    percent = e.offsetX / e.currentTarget.clientWidth
    progress = percent*100

    $("#js-plitem-info-progress-bar").width("#{progress}%")
    playing = @player.get('playing')

    if playing
      seekToSec = playing.get('length')*percent
      @player.seekTo(seekToSec)

  initialize: ->
    @player = @model
    @player.bind("change:progress", (model,progress) =>
      this.updateProgressBar(progress)
    )

    @player.bind("change:playing", (model,progress) =>
      @render()
    )

    this.render()

  updateProgressBar: (progress) ->
    if (progress == 0 or isNaN(progress))
      progress = 0

    playing = @player.get("playing")

    if playing
      fb = playing.get("length")*(progress/100)
      fe = playing.get("length") - playing.get("length")*(progress/100)
      $("#js-plitem-from-begining").html(fb.toMinSec())
      $("#js-plitem-from-end").html("-#{fe.toMinSec()}")

    $("#js-plitem-info-progress-bar").width("#{progress}%")

  render: ->
    playing = @player.get("playing")
    $(@el).html(@template({plitem: playing}))
