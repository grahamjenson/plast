class Plast.Views.Playlist extends Backbone.View

  template: JST['playlists/playlist']

  constructor: (playlist) ->
    super()
    @playlist = playlist
    console.log(@playlist)
    @playlist.bind('change', (e) =>
      console.log(e)
      this.render()
    )
    @playlist.get("plitems").bind('change', (e) =>
      console.log(e.changedAttributes())
      this.render()
    )

  render: ->
    console.log("render playlist")
    lastplayed = @playlist.getLastPlayed()

    console.log(lastplayed)
    $(@el).html(@template(items: @playlist.getOrderedPLItems(), playingitem : lastplayed))

    for plrow in $(@el).find("#playlist_list tbody tr")
      $(plrow).data("plitem",@playlist.get("plitems").get(plrow.id))
    $(@el).find("#playlist_list tbody").sortable({"stop" : (e,ui) => this.droppedOrder(e,ui)}).disableSelection()
    this

  droppedOrder: (e,ui)->
    i = 0
    for plrow in $("#playlist_list tbody tr")
      plitem = $(plrow).data("plitem")
      i += 1
      diff = plitem.attributes.order - i
      if(diff != 0)
        plitem.vote(diff)
      plitem.attributes.order = i
    @playlist.trigger("change")
