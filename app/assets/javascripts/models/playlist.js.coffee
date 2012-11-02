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

  additem: (url, callbacks) ->
    callbacks = {} if not callbacks
    pli = new Plast.Models.Plitem({"url" : url})
    @get("plitems").add(pli)
    pli.save({}, {
      success: =>
        callbacks.success() if callbacks.success
      error: ->
        callbacks.error() if callbacks.error})
    @trigger("change")

  fetch: (options) ->
    console.log("fetch")
    super(options)
    @get("plitems").fetch()