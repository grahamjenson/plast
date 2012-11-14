class Plast.Views.Plitem extends Backbone.View

  events:
    'click .remove-action' : (e) -> this.remove(e)
    'click .play-action' : (e) -> this.play(e)
    'click .pause-action' : (e) -> this.pause(e)

  template: JST['playlists/plitem']
  tagName: "tr"

  initialize: ->
    @plitem = this.model
    @player = @attributes.player

    this.render()

  render: ->
    state = 0
    if @plitem == @player.get("playing")
      state = 1
    else if @plitem.get("played")
      state = 2

    $(@el).addClass("plitem-row").html(@template(plitem : @plitem, state: state))
    $(@el).data("plitem",@plitem)
    this

  remove: (e) ->
    plitem = $(e.target).parents(".plitem-row").data("plitem")
    console.log("remove #{plitem.get('title')}")
    plitem.remove()

  play: (e) ->
    console.log("play")

  pause: (e) ->
    console.log("pause")