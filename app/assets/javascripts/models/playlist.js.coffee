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
    if @get("readonly")
      @refresh_time = 240000
    else
      @refresh_time = 60000
    @resetRefresh()

  resetRefresh: (time)->
    clearInterval(@refresh)
    @refresh = setInterval( =>
      this.fetch()
    ,@refresh_time)

  add_search_item_no_save: (sitem) ->
    pli = new Plast.Models.Plitem({
      "mediaid" : sitem.mediaid,
      "playername": sitem.playername,
      playlist_id: this.id,
      title: sitem.title,
      thumbnail: sitem.thumbnail,
      length: sitem.duration
      })
    @get("plitems").add(pli)
    return pli

  add_search_item: (sitem) =>
    @resetRefresh()
    pli = @add_search_item_no_save(sitem)
    this.add_post([pli])

  add_search_items: (sitems) ->
    @resetRefresh()
    plis = (@add_search_item_no_save(ytitem) for ytitem in sitems)
    this.add_post(plis)

    #pli.save({}, {
    #  success: =>
    #    callbacks.success() if callbacks.success
    #    @trigger("change")
    #  error: (model,xhr) ->
    #    @get("plitems").remove(pli)
    #    callbacks.error(model,xhr) if callbacks.error})

  parse: (data) ->
    console.log("Parsing Playlist")

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
    @delay_save()

  delay_save: ->
    clearTimeout(@delayed_save)
    @delayed_save = setTimeout(
      => @save()
    , 2000)

  remove: (plitem) ->
    @resetRefresh()
    this.get("plitems").remove(plitem)
    $.post("#{@url()}/remove", {plitem_id: plitem.id});

  add_post: (plis) ->
    $.post("#{@url()}/add_plitems", {plitems: (pli.as_json() for pli in plis)}).success((data) =>
      this.set(this.parse(data))
    );

  branch: ->
    $.post("#{@url()}/branch", {plitems: (pli.as_json() for pli in @.get('plitems').models)}, (e) ->
      window.location = "/playlist/#{e.id}"
    )

  getPlayableItems: ->
    this.get("plitems").getPlayableItems()

  getOrderedPLItems: ->
    this.get("plitems").getOrderedPLItems()

  getLastPlayed: ->
    this.get("plitems").getLastPlayed()

  makeAllPlayable: ->
    this.get("plitems").makeAllPlayable()
