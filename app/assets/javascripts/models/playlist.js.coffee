class Plast.Models.Playlist extends Backbone.RelationalModel
  urlRoot: ->
    if this.get("readonly")
      return "/api/read_only_playlists/"
    else
      return "/api/playlists/"


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
    @resetRefresh()

  resetRefresh: ->
    clearInterval(@refresh)
    @refresh = setInterval(=>
      this.fetch()
    ,20000)

  add_yt_item_no_save: (ytitem) ->
    pli = new Plast.Models.Plitem({
      "youtubeid" : ytitem.id,
      playlist_id: this.id,
      title: ytitem.title,
      thumbnail: ytitem.thumbnail.sqDefault,
      length: ytitem.duration
      })
    @get("plitems").add(pli)

  add_yt_item: (ytitem) =>
    @resetRefresh()
    @add_yt_item_no_save(ytitem)
    this.save()

  add_yt_items: (ytitems) ->
    @resetRefresh()
    (@add_yt_item_no_save(ytitem) for ytitem in ytitems)
    this.save()

    #pli.save({}, {
    #  success: =>
    #    callbacks.success() if callbacks.success
    #    @trigger("change")
    #  error: (model,xhr) ->
    #    @get("plitems").remove(pli)
    #    callbacks.error(model,xhr) if callbacks.error})

  parse: (data) ->
    console.log("Parsing Playlist")
    console.log(data.plitems)

    if data.plitems
      newplis = (pli.id for pli in data.plitems)
      oldplis = this.getOrderedPLItems().map((p) -> p.id)
      changed = not _.isEqual(newplis,oldplis)
      if changed
        this.get("plitems").reset(data.plitems)

      delete data.plitems #Never let it handle this

    return super(data)

  reorderitems: (items) ->
    @resetRefresh()
    this.get("plitems").reorderitems(items)
    this.save()

  getPlayableItems: ->
    this.get("plitems").getPlayableItems()

  getOrderedPLItems: ->
    this.get("plitems").getOrderedPLItems()

  getLastPlayed: ->
    this.get("plitems").getLastPlayed()

  makeAllPlayable: ->
    this.get("plitems").makeAllPlayable()
