class Plast.Views.Playlist extends Backbone.View

  template: JST['playlists/playlist']

  events:
    'submit #new_plitem' : 'createItem'

  constructor: (playlist) ->
    super()
    @playlist = playlist
    console.log(@playlist)
    @playlist.bind('change', @render,this)

  render: ->
    console.log("render")
    $(@el).html(@template(playlist: @playlist))
    params = { allowScriptAccess: "always",play: true };
    atts = { id: "myytplayer" };
    swfobject.embedSWF("http://www.youtube.com/v/R_j2fW1-Lwo?version=3&enablejsapi=1&autoplay=1", "new_form_error", "1", "1", "9.0.0", null, null, params, atts)
    this

  createItem: (event) ->

    event.preventDefault()
    @playlist.additem($("#new_plitem_url").val(),
      {success: =>
        $("#new_plitem_url").val("")
      error: (model, xhr) =>
        errors = $.parseJSON(xhr.responseText).errors
        $("#new_form_error").text(errors)
        })




