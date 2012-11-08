class Plast.Models.Playlist extends Backbone.RelationalModel
  urlRoot: "/api/playlists"

  relations: [{
      type: Backbone.HasMany,
      key: 'plitems',
      relatedModel: 'Plast.Models.Plitem',
      collectionType: 'Plast.Collections.Plitems',
      reverseRelation:
        key: 'playlist',
        includeInJSON: 'uuid'
      }]


  initialize: ->
    setInterval(=>
      this.fetch()
    ,1000)

  additem: (ytitem, callbacks = {}) ->
    pli = new Plast.Models.Plitem({
      "youtubeid" : ytitem.id,
      playlist_id: this.id,
      playlist: this,
      title: ytitem.title ,
      thumbnail: ytitem.thumbnail.sqDefault,
      length: ytitem.duration
      })

    pli.save({}, {
      success: =>
        @get("plitems").add(pli)
        pli.set({"order": this.get("plitems").size()})
        callbacks.success() if callbacks.success
        @trigger("change")
      error: (model,xhr) ->
        callbacks.error(model,xhr) if callbacks.error})

  fetchplitems: (options) ->
    @get("plitems").fetch(
      {
      add: true,
      success: =>
        i = 0
        changed = false
        for pli in this.get("plitems").models
          if not pli.get("order")
            i += 1
            changed = true
            pli.set({"order": i})
          else
            i = pli.get("order")
        this.trigger("change") if changed
        options.success() if options && options.success
      })

  fetch: (options) ->
    super({
      success: =>
        this.fetchplitems(options)
      })


  getPlayableItems: ->
    this.fetch()
    results = (plitem for plitem in this.get("plitems").models when not plitem.get("played"))
    results = _(results).sortBy (plitem) -> [plitem.order, plitem.get("updated_at")]
    return results

  getOrderedPlitems: ->
    this.fetch()
    results =  this.get("plitems").models
    results = _(results).sortBy (plitem) -> [plitem.order, plitem.get("updated_at")]
    return results

  getLastPlayed: ->
    results = (plitem for plitem in this.get("plitems").models when plitem.get("played"))
    results = _(results).sortBy (plitem) -> [plitem.get("played")]
    return results.reverse()[0]

  makeAllPlayable: ->
    (plitem.set("played",false) for plitem in this.get("plitems").models)
