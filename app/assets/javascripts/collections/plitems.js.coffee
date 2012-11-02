class Plast.Collections.Plitems extends Backbone.Collection
  model: Plast.Models.Plitem

  url: -> "/api/playlists/#{@playlist.id}/plitems"

  constructor: ->
    super()
    this.bind('add', (pli) ->
      @playlist.trigger("change"))
    this.bind('reset', (pli) ->
      @playlist.trigger("change"))