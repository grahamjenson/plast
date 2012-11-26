class Plast.Views.FullSideBar extends Backbone.View

  collaborate: JST['side_bar/collaborate_container']
  create: JST['side_bar/create_container']
  share: JST['side_bar/share_container']

  initialize: ->
    @playlist = @model
    #CREATE
    $('#js-create-container').html(@create({playlist: @playlist}))

    $('.js-branch-link').click(=>
      @playlist.branch()
    )

    #COLLABORATE
    if not @playlist.get("readonly")
      collaborate_link = "http://plysit.com/playlist/#{@playlist.id}"
      $('#js-collaborate-container').html(@collaborate({share_link: collaborate_link}))
      #$('.js-qrcode-collaborate').qrcode({width: 64,height: 64,text: collaborate_link});



    #SHARE
    share_link = "http://plysit.com/p/#{@playlist.get('read_only_id')}"
    $('#js-share-container').html(@share({share_link: share_link}))
    #$('.js-qrcode-share').qrcode({width: 64,height: 64,text: share_link});

    $('.js-copybox').click((e) -> $(e.target).focus(); $(e.target).select();)
    this