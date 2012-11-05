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
    this
