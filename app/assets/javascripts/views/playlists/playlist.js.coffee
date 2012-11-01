class Plast.Views.Playlist extends Backbone.View

  template: JST['playlists/playlist']

  events:
    'submit #new_plitem' : 'createItem'

  constructor: (playlist) ->
    super()
    @playlist = playlist
    @playlist.on('change',@render,this)

  render: ->
    $(@el).html(@template(playlist: @playlist))
    this

  createItem: (event) ->
    console.log("CreateItem")
    event.preventDefault()
    pli = new Plast.Models.Plitem({url : $("#new_plitem_url").val(), uuid : @playlist.id})

    pli.save({},{
    success: =>
      $("#new_plitem_url").val("")
    error: (model, xhr) =>
      errors = $.parseJSON(xhr.responseText).errors
      $("#new_form_error").text(errors)
      })
    @playlist.fetch()


