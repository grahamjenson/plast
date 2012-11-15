class Plast.Models.ReadOnlyPlaylist extends Backbone.RelationalModel
  urlRoot: "/api/read_only_playlists"

  relations: [{
      type: Backbone.HasMany,
      key: 'plitems',
      relatedModel: 'Plast.Models.ReadOnlyPlitem',
      collectionType: 'Plast.Collections.ReadOnlyPlitems',
      reverseRelation:
        key: 'playlist',
        includeInJSON: 'id'
      }]


  initialize: ->
    setInterval(=>
      this.fetch()
    ,10000)


  fetch: (options = {}) ->
    console.log("FETCHING READONLY PLAYLIST")
    previousSize = @get("plitems").size()
    super(
      success: =>
        @get("plitems").fetch(
          success: =>
            if previousSize != @get("plitems").size()
              @trigger("change")
            options.success() if options.success
          silent: true
          )
      )

  getPlayableItems: ->
    this.get("plitems").getPlayableItems()

  getOrderedPLItems: ->
    this.get("plitems").getOrderedPLItems()

  getLastPlayed: ->
    this.get("plitems").getLastPlayed()

  makeAllPlayable: ->
    this.get("plitems").makeAllPlayable()
