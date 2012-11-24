class Plast.Views.Plitem extends Backbone.View

  events:
    'click .action.remove' : (e) -> this.remove(e)
    'click .action.play' : (e) -> this.play(e)
    'click .action.pause' : (e) -> this.pause(e)
    'click .action.resume' : (e) -> this.resume(e)

  template: JST['playlists/plitem']
  tagName: "ul"

  initialize: ->
    @plitem = this.model
    @player = @attributes.player

    @player.bind("change:state", (model,state) =>
      this.stateDirector(state)
    )

    this.render()

  stateDirector: (state) =>
    switch state
      when Plast.Models.Player.STATE_NOTREADY then
      when Plast.Models.Player.STATE_READY then
      when Plast.Models.Player.STATE_PLAYING then this.isplaying()
      when Plast.Models.Player.STATE_PAUSED then this.ispaused()

  isplaying: ->
    $(".action.pause").removeClass("hide")
    $(".action.resume").addClass("hide")

  ispaused: ->
    $(".action.pause").addClass("hide")
    $(".action.resume").removeClass("hide")

  render: ->
    state = Plast.Views.Plitem.NOT_PLAYED_STATE
    if @plitem == @player.get("playing")
      state = Plast.Views.Plitem.PLAYING_STATE
    else if @plitem.get("played")
      state = Plast.Views.Plitem.PLAYED_STATE

    $(@el).addClass("js-plitem-row playlist").html(@template(plitem : @plitem, state: state, player: @player))
    $(@el).data("plitem",@plitem)
    this

  remove: (e) ->
    plitem = $(e.target).parents(".js-plitem-row").data("plitem")
    console.log("remove #{plitem.get('title')}")
    console.log(@plitem)
    @plitem.get("playlist").remove(plitem)

  play: (e) ->
    @player.skipToItem(@plitem)

  pause: (e) ->
    @player.pause()

  resume: (e) ->
    @player.resumeplaying()

Plast.Views.Plitem.NOT_PLAYED_STATE = 0
Plast.Views.Plitem.PLAYING_STATE = 1
Plast.Views.Plitem.PLAYED_STATE = 2