class Plast.Views.Plitem extends Backbone.View

  template: JST['playlists/plitem']
  tagName: "tr"

  initialize: ->
    @plitem = this.model
    this.render()

  render: ->
    clazz = ""
    if @plitem.get("played")
      clazz = "played"
    $(@el).addClass("plitem-row").addClass(clazz).html(@template(plitem : @plitem))
    this

  remove: (e) ->
    plitem = $(e.target).parents("tr").data("plitem")
    plitem.remove()