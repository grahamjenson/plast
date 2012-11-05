class Plast.Views.Search extends Backbone.View


  template: JST['playlists/search']

  events:
    'click .srlink' : 'srclick'
    'submit #searchyt' : 'searchyt'
    'input #serchtext' : 'searchyt'

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
    #TODO make sure $("#searchresults") has been dropped

    if not $("#searchresults").parent().hasClass('open')
      $("#searchresults").parent().toggleClass('open')
    lol = $("#serchtext").val()
    res = @results
    $("#searchresults").html("Waiting for results...")
    $.getJSON("https://gdata.youtube.com/feeds/api/videos?q=#{lol}&orderby=relevance&max-results=4&v=2&category=music&alt=jsonc", {}, (d) ->
      if not d.data.items
        $("#searchresults").html("No results")
        return
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
      success: ->
        $("#serchtext").focus()
        $("#serchtext").select()
      error: (model, xhr) =>
        errors = $.parseJSON(xhr.responseText).errors
        console.log(errors)
        })

  change: ->
    console.log("change")

  select: ->
    console.log("select")
