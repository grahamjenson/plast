class Plast.Collections.Plitems extends Backbone.Collection
  model: Plast.Models.Plitem
  url: -> "/api/playlists/#{@playlist.id}/plitems"
