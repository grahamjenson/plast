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

  additem: (youtubeid, callbacks = {}) ->
    pli = new Plast.Models.Plitem({"youtubeid" : youtubeid})
    @get("plitems").add(pli)
    pli.save({}, {
      success: =>
        callbacks.success() if callbacks.success
        @trigger("change")
      error: ->
        callbacks.error() if callbacks.error})


  fetch: (options) ->
    super(options)
    @get("plitems").fetch()