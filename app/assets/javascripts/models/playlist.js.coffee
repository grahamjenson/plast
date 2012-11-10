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
    ,10000)

  additem: (ytitem, callbacks = {}) =>
    pli = new Plast.Models.Plitem({
      "youtubeid" : ytitem.id,
      playlist_id: this.id,
      title: ytitem.title,
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


  fetch: (options = {}) ->
    console.log("FETCHING")
    super({
      success: =>
        @get("plitems").fetch()
        options.success() if options.success
      })


  reorderitems: (items) ->
    this.get("plitems").reorderitems(items)
    this.trigger("change")

  getPlayableItems: ->
    this.get("plitems").getPlayableItems()

  getOrderedPLItems: ->
    this.get("plitems").getOrderedPLItems()

  getLastPlayed: ->
    this.get("plitems").getLastPlayed()

  makeAllPlayable: ->
    this.get("plitems").makeAllPlayable()
