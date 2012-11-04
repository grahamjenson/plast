class Plast.Views.Search extends Backbone.View


  template: JST['playlists/search']

  events:
    'submit #searchyt' : 'searchyt'
    'click .srlink' : 'srclick'


  constructor: (playlist) ->
    super()
    @playlist = playlist
    @results = {}

  render: ->
    console.log("render search")
    $(@el).html(@template())
    this

  searchyt: (event) =>
    event.preventDefault()
    lol = $("#serchtext").val()
    @results = {}
    res = @results
    $.getJSON("https://gdata.youtube.com/feeds/api/videos?q=#{lol}&orderby=relevance&max-results=4&v=2&category=music&alt=jsonc", {}, (d) ->
      window.hui = d
      for item in d.data.items
        res[item.id] = item
      srhtml = JST["playlists/searchresult"](items : d.data.items)
      $("#searchresults").html(srhtml)
    )


  srclick: (e) =>
    it = $(e.currentTarget).attr("dataid")
    item = @results[it]
    @playlist.additem(item,
      {
      error: (model, xhr) =>
        errors = $.parseJSON(xhr.responseText).errors
        console.log(errors)
        })



