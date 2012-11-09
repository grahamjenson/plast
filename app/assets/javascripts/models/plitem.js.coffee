class Plast.Models.Plitem extends Backbone.RelationalModel
  url: -> "/api/playlists/#{@get('playlist_id')}/plitems"

  remove: (plitemvotes) ->
    $.post("#{@url()}/#{this.id}/remove", {});
    this.set("hidden",true)