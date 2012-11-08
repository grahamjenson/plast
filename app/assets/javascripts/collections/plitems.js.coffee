class Plast.Collections.Plitems extends Backbone.Collection
  model: Plast.Models.Plitem

  url: -> "/api/playlists/#{@playlist.id}/plitems"

  vote: (plitemvotes) ->
    if Object.keys(plitemvotes).length > 0
      $.post("#{@url()}/vote", {votes: plitemvotes} );
