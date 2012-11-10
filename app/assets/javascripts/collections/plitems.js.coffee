class Plast.Collections.Plitems extends Backbone.Collection
  model: Plast.Models.Plitem

  url: -> "/api/playlists/#{@playlist.id}/plitems"

  reorderitems: (items) ->
    votes = {}
    i = 0
    for plitem in items
      i += 1
      diff = plitem.attributes.order - i
      if(diff != 0)
        votes[plitem.id] = diff
      plitem.attributes.order = i
    this.vote(votes)

  vote: (plitemvotes) ->
    if Object.keys(plitemvotes).length > 0
      $.post("#{@url()}/vote", {votes: plitemvotes} );

  fetch: (options = {}) ->
    super(
      {
      add: true,
      success: =>
        i = 0
        for pli in this.getOrderedPLItems()
          if not pli.get("order")
            i += 1
            pli.set({"order": i})
          else
            i = pli.get("order")
        options.success() if options.success
      error: -> options.error
      }
      )

  getPlayableItems: ->
    results = this.getOrderedPLItems()
    results = (plitem for plitem in this.models when not plitem.get("played"))
    return results

  getOrderedPLItems: ->
    results = this.models
    results = (plitem for plitem in this.models when not plitem.get("hidden"))
    results = _(results).sortBy this.comparator
    return results

  getLastPlayed: ->
    results = (plitem for plitem in this.models when plitem.get("played"))
    results = _(results).sortBy (plitem) -> [plitem.get("played")]
    return results.reverse()[0]

  makeAllPlayable: ->
    (plitem.set("played",false) for plitem in this.models)