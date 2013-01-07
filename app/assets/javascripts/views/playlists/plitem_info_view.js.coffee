class Plast.Views.PlitemInfoView extends Backbone.View

  events:
    'click .seek' : (e) -> console.log(e)

  template: JST['playlists/plitem_info']

  initialize: ->
    @player = @model
    this.render()

  render: ->
    $(@el).html(@template())
