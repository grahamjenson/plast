class Plast.Collections.Plitems extends Backbone.Collection
  model: Plast.Models.Plitem

  url: -> "/api/playlists/#{@playlist.id}/plitems"

  reorderitems: (items) ->
    #newsort contains removed items
    $.post("#{@url()}/reorder", {order: (item.id for item in items)});

    this.reset(items)
    this.vote(diffs)


  getPlayableItems: ->
    results = this.getOrderedPLItems()
    results = (plitem for plitem in this.models when not plitem.get("played"))
    return results

  getOrderedPLItems: ->
    results = this.models
    results = (plitem for plitem in this.models when not plitem.get("hidden"))
    return results

  getLastPlayed: ->
    results = (plitem for plitem in this.models when plitem.get("played"))
    results = _(results).sortBy (plitem) -> [plitem.get("played")]
    return results.reverse()[0]

  makeAllPlayable: ->
    (plitem.set("played",false) for plitem in this.models)

  hidePlitem: (plitem) ->
    plitem.set(hidden,true)
    plitem