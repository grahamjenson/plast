class Plast.Views.Plitem extends Backbone.View


  template: JST['playlists/plitem']
  tagName: "tr"

  initialize: ->
    @plitem = this.model
    @player = @attributes.player

    @player.bind("change:progress", (model,progress) =>
        this.updateProgressBar(progress)
      )

    this.render()

  updateProgressBar: (progress) ->
    if (progress == 0 or isNaN(progress))
      progress = 0
    $("#bar").width("#{progress}%")

  render: ->
    state = 0
    if @plitem == @player.get("playing")
      state = 1
    else if @plitem.get("played")
      state = 2

    $(@el).addClass("plitem-row").html(@template(plitem : @plitem, state: state))
    $(@el).data("plitem",@plitem)
    this

  remove: (e) ->
    plitem = $(e.target).parents("tr").data("plitem")
    plitem.remove()