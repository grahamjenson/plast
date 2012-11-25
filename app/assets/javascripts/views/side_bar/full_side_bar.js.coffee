class Plast.Views.FullSideBar extends Backbone.View

  collaborate: JST['side_bar/collaborate_container']
  create: JST['side_bar/create_container']
  share: JST['side_bar/share_container']

  initialize: ->
    $('#js-create-container').html(@create())
    $('#js-collaborate-container').html(@collaborate())
    $('#js-share-container').html(@share())
    this