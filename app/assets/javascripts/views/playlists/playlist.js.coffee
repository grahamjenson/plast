class Plast.Views.Playlist extends Backbone.View

  template: JST['playlists/playlist']

  events:
    'click .remove-btn' : (e) -> this.remove(e)

  initialize: ->
    @playlist = this.model

    @playlistSelector = "#playlist_list tr"

    @playlist.bind('change', (e) =>
      this.render()
    )

    @playlist.get("plitems").bind('change', (e) =>
      console.log(e.changedAttributes())
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
    view = new Plast.Views.Plitem({model: plitem})
    $("#plitmeviews").append(view.render().el)

  droppedOrder: (e,ui)->
    console.log(e)
    console.log(ui)
    items = ($(plrow).data("plitem") for plrow in $(@playlistSelector))
    @playlist.reorderitems(items)

  remove: (e) ->
    plitem = $(e.target).parents("tr").data("plitem")
    plitem.remove()