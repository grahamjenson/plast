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