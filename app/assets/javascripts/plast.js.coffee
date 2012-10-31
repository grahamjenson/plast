window.Plast =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    new Plast.Routers.Playlists()
    Backbone.history.start()

$(document).ready ->
  Plast.init()
