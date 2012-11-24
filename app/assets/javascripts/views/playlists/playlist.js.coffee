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
    , 100)

  delayedrender: ->
    console.log("render playlist")
    lastplayed = @playlist.getLastPlayed()

    $(@el).html(@template())
    for plitem in @playlist.getOrderedPLItems()
      @appendPlitem(plitem)

    if not @playlist.get("readonly")
      $(@el).find("#js-plitem-container").sortable({
        "stop" : (e,ui) => this.droppedOrder(e,ui),
        "cursor": "pointer",
        'containment': $('#js-plitem-container'),
        'start': (e, ui) => @highlightListItem(e),
        'stop': (e, ui) => @deHighlightListItem(e)
      }).disableSelection()

    this

  appendPlitem: (plitem) ->
    view = new Plast.Views.Plitem(
      model: plitem,
      attributes:
        player: @player)
    $("#js-plitem-container").append(view.render().el)

  droppedOrder: (e, ui)->
    items = ($(plrow).data("plitem") for plrow in $(".js-plitem-row"))
    @playlist.reorderitems(items)

  highlightListItem: (e) ->
    console.log e.target
    ul_item = $(e.target).closest('ul')
    ul_item.addClass('active-sortable')


  deHighlightListItem: (e) ->
    console.log e.target
    ul_item = $(e.target).closest('ul')
    ul_item.css('background-color', '#04C')
    ul_item.removeClass('active-sortable')
    ul_item.animate({'background-color' : 'white', 'color' : 'black'}, 400)