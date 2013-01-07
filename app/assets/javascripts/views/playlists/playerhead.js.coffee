class Plast.Views.PlayerHead extends Backbone.View

  template: JST['playlists/playerhead']

  events:
    'click #back' : -> @player.back()
    'click #play' : -> @player.play()
    'click #forward' : -> @player.forward()
    'click #pause' : -> @player.pause()
    'click #fullscreen': -> @player.fullscreen()


  initialize: ->
    @player = this.model

    @player.bind("change:state", (model,state) =>
      this.stateDirector(state)
    )

    this.render()

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

  render: ->
    $(@el).html(@template(plitem: @player))

    this.stateDirector(@player.get("state"))
    this



