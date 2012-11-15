class Plast.Models.ReadOnlyPlitem extends Backbone.RelationalModel
  url: -> "/api/read_only_playlists/#{@get('playlist_id')}/read_only_plitems"

