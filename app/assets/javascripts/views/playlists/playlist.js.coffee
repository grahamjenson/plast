class Plast.Views.Playlist extends Backbone.View

  template: JST['playlists/playlist']

  initialize: ->
    @playlist = this.model
    @player = @attributes.player

    @player.bind("change:playing", =>
      console.log("change playing event")
      this.render())

    @playlist.bind('change', (e) =>
      console.log("change event")
      this.render()
    )

    @playlist.get("plitems").bind('remove', (e) =>
      console.log("remove event")
      this.render()
    )

    @playlist.get("plitems").bind('change', (e) =>
      console.log("plitems change event")
      this.render()
    )

    @playlist.get("plitems").bind('add', (e) =>
      console.log("plitems add event")
      this.render()
    )

    @playlist.get("plitems").bind('reset', (e) =>
      console.log("plitems reset event")
      this.render()
    )


    @player.bind("change:progress", (model,progress) =>
        this.updateProgressBar(progress)
      )

    this.render()

  updateProgressBar: (progress) ->
    if (progress == 0 or isNaN(progress))
      progress = 0
    $("#js-progress-bar").width("#{progress}%")

  render: ->
    clearTimeout(@t)
    @t = setTimeout(
      => @delayedrender()
    , 50)

  delayedrender: ->
    console.log("render playlist")
    lastplayed = @playlist.getLastPlayed()

    $(@el).html(@template())
    for plitem in @playlist.getOrderedPLItems()
      @appendPlitem(plitem)

    if not @playlist.get("readonly")
      $(@el).find("#playlist_list tbody:first").sortable({
        "stop" : (e,ui) => this.droppedOrder(e,ui),
        "cursor": "pointer"
      }).disableSelection()

    this

  appendPlitem: (plitem) ->
    view = new Plast.Views.Plitem(
      model: plitem,
      attributes:
        player: @player)
    $("#plitmeviews").append(view.render().el)

  droppedOrder: (e,ui)->
    items = ($(plrow).data("plitem") for plrow in $(".plitem-row"))
    @playlist.reorderitems(items)
