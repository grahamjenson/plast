class Plast.Models.Plitem extends Backbone.RelationalModel
  url: -> "/api/playlists/#{@get('playlist_id')}/plitems"
