class Plast.Models.Plitem extends Backbone.RelationalModel
  url: -> "/api/playlists/#{@get('playlist').id}/plitems"
