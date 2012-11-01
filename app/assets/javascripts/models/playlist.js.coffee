class Plast.Models.Playlist extends Backbone.Model
  urlRoot: "/api/playlists"

  defaults: {
    "plitems": []
  }

  constructor: (attributes,options) ->
    Backbone.Model.apply( this, arguments )
    for plitem in this.get("plitems")
        npl = new Plast.Models.Plitem({url : plitem.url})
    console.log (this.get("plitems"))
    this