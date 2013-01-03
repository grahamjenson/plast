class Plast.Models.Plitem extends Backbone.RelationalModel
  url: =>
    if @collection.playlist.get("readonly")
      return "/api/read_only_playlists/#{@collection.playlist.id}/read_only_plitems"
    else
      return "/api/playlists/#{@collection.playlist.id}/plitems"

  as_json: ->
    plitem = this
    return {
      mediaid: plitem.get("mediaid"),
      playername: plitem.get("playername"),
      title: plitem.get("title"),
      thumbnail: plitem.get("thumbnail"),
      length: plitem.get("length")
    }