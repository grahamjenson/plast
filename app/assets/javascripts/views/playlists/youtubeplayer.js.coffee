class Plast.Views.YoutubePlayer extends Backbone.View

  template: JST['playlists/youtubeplayer']
  events:
    'click #showvideobtn' : 'toggleVideo'

  el: $('#youtubeplayer')

  @animator

  initialize: ->
    console.log("Asd")

  toggleVideo: ->
    if this.animator
      return
    endleft = -600
    console.log("toggle view wvideo")
    left = $("#sideplayer").position().left
    invisible = (left == endleft)
    frames = 10
    frame = 0

    if invisible
      goto = 0
    else
      goto = endleft

    @animator = setInterval( =>
      nl = (frame/frames)
      if invisible
        nl = 1- nl
      nl = nl*(endleft)
      frame += 1
      $("#sideplayer").css({left: "#{nl}px"})

      if frame == frames
        $("#sideplayer").css({left: "#{goto}px"})
        clearInterval(this.animator)
        this.animator = null
    , 25)

  render: ->
    console.log("render youtubeplayer")
    $(@el).html(@template())
    this
