class Plast.Views.PlayerHead extends Backbone.View

  template: JST['playlists/playerhead']

  events:
    'click #back' : -> @player.back()
    'click #play' : -> @player.play()
    'click #forward' : -> @player.forward()
    'click #pause' : -> @player.pause()
    'click #showvideo': -> this.toggleVideo()

  el : $('#playerhead')

  constructor: (player) ->
    super()
    @player = player
    @player.bind("change:state", (model,state) =>
      this.stateDirector(state)
    )

    @player.bind("change:progress", (model,progress) =>
        this.updateProgressBar(progress)
    )


  stateDirector: (state)->
    switch state
      when Plast.Models.Player.STATE_NOTREADY then this.notReady()
      when Plast.Models.Player.STATE_READY then this.ready()
      when Plast.Models.Player.STATE_PLAYING then this.playing()
      when Plast.Models.Player.STATE_PAUSED then this.paused()

  notReady: ->
    window.hui = @el
    $(@el).find(".playerbtn").addClass("disabled")
    $(".playerbtn").addClass("disabled")

    $(@el).find("#pause").hide()
    $("#pause").hide()

  ready: ->
    console.log("enable")
    $(".playerbtn").removeClass("disabled")

  playing: ->
    $("#pause").show()
    $("#play").hide()

  paused: ->
    $("#pause").hide()
    $("#play").show()

  updateProgressBar: (progress) ->
    if (progress == 0 or isNaN(progress))
      progress = 100
    $("#bar").width("#{progress}%")

  toggleVideo: ->
    $("#showvideo").popover({
      html: true,
      placement: "bottom",
      title: "VIDEO"
      content: "<div id='tmpytvideo'></div>",
      selector: "#showvideo",
      trigger: "manual",

      })
    if $("#tmpytvideo").length == 0
      $("#showvideo").popover('show')
      $("#outerytplayer").detach().prependTo("#tmpytvideo");
    else
      $("#outerytplayer").detach().prependTo(".invisible");
      $("#showvideo").popover('hide')

  render: ->
    $(@el).html(@template(plitem: @player))

    this.stateDirector(@player.get("state"))
    this

