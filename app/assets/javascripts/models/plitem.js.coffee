class Plast.Models.Plitem extends Backbone.RelationalModel
  url: ->
    if @collection.playlist.get("readonly")
      return "/api/read_only_playlists/#{@collection.playlist.id}/read_only_plitems"
    else
      return "/api/playlists/#{@collection.playlist.id}/plitems"

  remove: () ->
    $.post("#{@url()}/#{this.id}/remove", {});
    this.collection.remove(this)