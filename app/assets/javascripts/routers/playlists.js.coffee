class Plast.Routers.Playlists extends Backbone.Router
  routes:
    '': 'index'
    'playlists/:uuid' : 'showpl'

  index: ->
    view = new Plast.Views.PlaylistsIndex()
    $('#container').html(view.render().el)

  showpl: (uuid) ->
    alert "asdsad #{uuid}"