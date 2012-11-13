class Plast.Views.Playlist extends Backbone.View

  template: JST['playlists/playlist']

  events:
    'click .remove-btn' : (e) -> this.remove(e)

  initialize: ->
    @playlist = this.model
    @player = @attributes.player

    @player.bind("change:playing", =>
      console.log("change playing event")
      this.render())

    @playlist.bind('change', (e) =>
      console.log("change event")
      this.render()
    )

    @playlist.get("plitems").bind('change', (e) =>
      console.log("plitems change event")
      console.log(e.changedAttributes())
      this.render()
    )

    @playlist.get("plitems").bind('reset', (e) =>
      console.log("plitems reset event")
      this.render()
    )

    this.render()

  render: ->
    console.log("render playlist")
    lastplayed = @playlist.getLastPlayed()

    $(@el).html(@template())
    for plitem in @playlist.getOrderedPLItems()
      @appendPlitem(plitem)

    $(@el).find("#playlist_list tbody:first").sortable({
      "stop" : (e,ui) => this.droppedOrder(e,ui),
      "cursor": "pointer"
    }).disableSelection()
    this

  appendPlitem: (plitem) ->
    view = new Plast.Views.Plitem(
      model: plitem,
      attributes:
        player: @player)
    $("#plitmeviews").append(view.render().el)

  droppedOrder: (e,ui)->
    items = ($(plrow).data("plitem") for plrow in $(".plitem-row"))
    @playlist.reorderitems(items)
