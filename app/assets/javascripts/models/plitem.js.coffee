class Plast.Models.Plitem extends Backbone.RelationalModel
  url: =>
    if @collection.playlist.get("readonly")
      return "/api/read_only_playlists/#{@collection.playlist.id}/read_only_plitems"
    else
      return "/api/playlists/#{@collection.playlist.id}/plitems"

  as_json: ->
    plitem = this
    return {
      youtubeid: plitem.get("youtubeid"),
      title: plitem.get("title"),
      thumbnail: plitem.get("thumbnail"),
      length: plitem.get("length")
    }