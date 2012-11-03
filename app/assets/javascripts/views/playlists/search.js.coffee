class Plast.Views.Search extends Backbone.View


  template: JST['playlists/search']

  events:
    'submit #searchyt' : 'searchyt'
    'click .srlink' : 'srclick'

  constructor: (playlist) ->
    super()
    @playlist = playlist

  render: ->
    console.log("render search")
    $(@el).html(@template())
    this

  searchyt: (event) ->
    event.preventDefault()
    lol = $("#serchtext").val()
    $.getJSON("https://gdata.youtube.com/feeds/api/videos?q=#{lol}&orderby=relevance&max-results=4&v=2&alt=json", {}, (d) ->
      window.hui = d
      console.log(d.data)
      srhtml = JST["playlists/searchresult"](items : d.feed.entry)
      $("#searchresults").html(srhtml)
    )


  srclick: (e) ->
    @playlist.additem(e.currentTarget.id,
      {success: =>

      error: (model, xhr) =>
        errors = $.parseJSON(xhr.responseText).errors
        console.log(errors)
        })



