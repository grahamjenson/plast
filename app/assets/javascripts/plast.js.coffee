window.Plast =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    Backbone.defaultrouter = new Plast.Routers.Playlists()
    Backbone.history.start()

$(document).ready ->
  Plast.init()
