class Plast.Models.Plitem extends Backbone.RelationalModel
  url: -> "/api/playlists/#{@collection.playlist.id}/plitems"

  remove: () ->
    $.post("#{@url()}/#{this.id}/remove", {});
    this.collection.remove(this)