class Plast.Views.PlaylistsIndex extends Backbone.View

  template: JST['playlists/index']

  render: ->
    $(@el).html(@template(items: "items go here"))
    this