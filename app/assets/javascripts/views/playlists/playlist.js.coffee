class Plast.Views.Playlist extends Backbone.View

  template: JST['playlists/playlist']

  events:
    'click .remove-btn' : (e) -> this.remove(e)

  playlistSelector = @playlistSelector

  initialize: ->
    @playlist = this.model

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

    $(@el).html(@template(items: @playlist.getOrderedPLItems(), playingitem : lastplayed))

    for plrow in $(@el).find(@playlistSelector)
      $(plrow).data("plitem",@playlist.get("plitems").get(plrow.id))
    $(@el).find("#playlist_list tbody").sortable({"stop" : (e,ui) => this.droppedOrder(e,ui)}).disableSelection()

    this

  droppedOrder: (e,ui)->
    items = ($(plrow).data("plitem") for plrow in $(@playlistSelector))
    @playlist.reorderitems(items)

  remove: (e) ->
    plitem = $(e.target).parents("tr").data("plitem")
    plitem.remove()