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

  STATE_INIT: 0
  STATE_PLAYING: 1
  STATE_PAUSED: 2

  initialize: ->
    this.set("state", @STATE_INIT)

  additem: (ytitem, callbacks = {}) ->
    console.log(ytitem)
    pli = new Plast.Models.Plitem({
      "youtubeid" : ytitem.id,
      playlist_id: this.id,
      title: ytitem.title ,
      thumbnail: ytitem.thumbnail.sqDefault,
      length: ytitem.duration,
      rating: 0})

    pli.save({}, {
      success: =>
        @get("plitems").add(pli)
        callbacks.success() if callbacks.success
        @trigger("change")
      error: (model,xhr) ->
        callbacks.error(model,xhr) if callbacks.error})


  fetch: (options) ->
    super(options)
    @get("plitems").fetch()

  getPlayableItems: ->
    results = (plitem for plitem in this.get("plitems").models when not plitem.get("played"))
    results = _(results).sortBy (plitem) -> [plitem.get("rating"), plitem.get("updated_at")]
    return results