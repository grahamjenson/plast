class Plast.Collections.Plitems extends Backbone.Collection
  model: Plast.Models.Plitem

  url: ->
    if @playlist.get("readonly")
      return "/api/read_only_playlists/#{@playlist.id}/read_only_plitems"
    else
      return "/api/playlists/#{@playlist.id}/plitems"

  reorderitems: (items) ->
    #newsort contains removed items
    this.reset(items)

  getPlayableItems: ->
    results = this.getOrderedPLItems()
    results = (plitem for plitem in this.models when not plitem.get("played"))
    return results

  getOrderedPLItems: ->
    results = this.models
    return results

  getLastPlayed: ->
    results = (plitem for plitem in this.models when plitem.get("played"))
    results = _(results).sortBy (plitem) -> [plitem.get("played")]
    return results.reverse()[0]

  makeAllPlayable: ->
    (plitem.set("played",false) for plitem in this.models)
