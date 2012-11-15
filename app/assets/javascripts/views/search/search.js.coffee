class Plast.Views.Search extends Backbone.View


  template: JST['search/search']

  events:
    'click .srlink' : 'srclick'
    'keydown .srlink' : 'srkey'
    'submit #searchyt' : 'delaysearch'
    'input #serchtext' : 'delaysearch'
    "click #serchtext" : 'openDropDown'


  initialize: ->
    @playlist = this.model
    this.render()

  render: ->
    console.log("render search")

    $('#searchyt').on('show', (e) ->
      console.log 'hello'
    )
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

    # Reset Searchs
    $("#videosearchresults").html(results_loading_string)
    $("#playlistsearchresults").html(results_loading_string)

    # Search Videos
    $.getJSON("https://gdata.youtube.com/feeds/api/videos?q=#{lol}&orderby=relevance&max-results=5&v=2&alt=jsonc", {}, (d) =>
      if not d.data.items
        $("#videosearchresults").html(no_results_found_string)
        return

      existing_playlist_youtube_ids = (item.attributes['youtubeid'] for item in @playlist.get('plitems').models)
      unique_video_search_results = (item for item in d.data.items when item.id not in existing_playlist_youtube_ids)[0..3]

      search_results_html = JST["search/videosearchresult"](items : unique_video_search_results)
      $("#videosearchresults").html(search_results_html)

      for item in unique_video_search_results
        $("##{item.id}").data("yto", {video: item})
    )

    # Search Playlists
    $.getJSON("https://gdata.youtube.com/feeds/api/playlists/snippets?q=#{lol}&orderby=relevance&max-results=5&v=2&alt=jsonc", {}, (d) =>
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
    $(e.currentTarget).parent().remove()
    @searchyt(e)
    if item.video
      this.addAnItem(item.video)
    if item.playlist
      #TODO does not add videos in correct order
      $.getJSON("https://gdata.youtube.com/feeds/api/playlists/#{item.playlist.id}?alt=jsonc&v=2&max-results=50", {}, (d) =>
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

  openDropDown: ->
    $('#js-help-container .step').animate(
      { opacity: 0, height: 0, 'margin-top': '-50px' }, 1000, ->
        $('#js-help-container').css('display', 'none')
    )