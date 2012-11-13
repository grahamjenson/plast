class Plast.Views.Search extends Backbone.View


  template: JST['search/search']

  events:
    'click .srlink' : 'srclick'
    'keydown .srlink' : 'srkey'
    'submit #searchyt' : 'delaysearch'
    'input #serchtext' : 'delaysearch'


  initialize: ->
    @playlist = this.model
    this.render()

  render: ->
    console.log("render search")
    $(@el).html(@template())
    this

  refocusonsearch: ->

  delaysearch: (e) ->
    e.preventDefault()
    clearTimeout(@t)
    @t = setTimeout(
      => @searchyt(e)
    , 500)

  searchyt: (event) =>
    console.log("searching")
    results_loading_string = "<div class='results-loading'><img src='/assets/loading.gif'></img><div>"
    no_results_found_string = "<div class='results-loading'>Sorry, no results were found.</div>"


    lol = $("#serchtext").val()
    res = @results
    #https://developers.google.com/youtube/2.0/developers_guide_protocol

    #reset searchs
    $("#videosearchresults").html(results_loading_string)
    $("#playlistsearchresults").html(results_loading_string)

    #launch video searchs
    $.getJSON("https://gdata.youtube.com/feeds/api/videos?q=#{lol}&orderby=relevance&max-results=5&v=2&alt=jsonc", {}, (d) ->
      if not d.data.items
        $("#videosearchresults").html(no_results_found_string)
        return
      srhtml = JST["search/videosearchresult"](items : d.data.items)
      $("#videosearchresults").html(srhtml)
      for item in d.data.items
        $("#"+item.id).data("yto", {video: item})
    )

    #search playlists
    $.getJSON("https://gdata.youtube.com/feeds/api/playlists/snippets?q=#{lol}&orderby=relevance&max-results=5&v=2&alt=jsonc", {}, (d) ->
      if not d.data.items
        $("#playlistsearchresults").html(no_results_found_string)
        return
      srhtml = JST["search/playlistsearchresult"](items : d.data.items)
      $("#playlistsearchresults").html(srhtml)
      for item in d.data.items
        $("#"+item.id).data("yto", {playlist: item})
    )

  srkey: (e) =>
    ENTER_CODE = 13
    if e.which == ENTER_CODE
      e.preventDefault()
      this.srclick(e)

  srclick: (e) =>
    e.preventDefault()
    item = $(e.currentTarget).data("yto")
    console.log(item)
    if item.video
      this.addAnItem(item.video)
    if item.playlist
      #TODO does not add videos in correct order
      $.getJSON("     https://gdata.youtube.com/feeds/api/playlists/#{item.playlist.id}?alt=jsonc&v=2&max-results=50", {}, (d) =>
        console.log(d)
        for yto in d.data.items
          item = yto.video
          this.addAnItem(item)
      )



  addAnItem: (item) ->
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

