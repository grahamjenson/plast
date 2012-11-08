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
    $(@el).html(@template(items: @playlist.getOrderedPlitems()))
    $(@el).find("#playlist_list tbody").sortable({"stop" : => this.droppedOrder()}).disableSelection()
    this

  droppedOrder: ->
    console.log("dropped check")