class Plast.Views.Playlist extends Backbone.View

  template: JST['playlists/playlist']

  constructor: (playlist) ->
    super()
    @playlist = playlist
    console.log(@playlist)
    @playlist.bind('change', @render,this)

  render: ->
    console.log("render playlist")
    $(@el).html(@template(playlist: @playlist))
    $(@el).find("#playlist_list tbody").sortable({}).disableSelection()
    this
