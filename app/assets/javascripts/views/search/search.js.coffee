class Plast.Views.Search extends Backbone.View


  template: JST['search/search']

  events:
    'click .srlink' : 'srclick'
    'keydown .srlink' : 'srkey'
    'submit #js-search-form' : 'delaysearch'
    'input #js-search-input' : 'delaysearch'


  initialize: ->
    @playlist = this.model
    @searcher = new Searcher()
    this.render()

  render: ->
    $(@el).html(@template())
    this

  delaysearch: (e) ->
    e.preventDefault()
    @dropdownResults()
    clearTimeout(@t)
    @t = setTimeout(
      => @searchYouTube(e)
    , 500)

  searchYouTube: (event) =>
    console.log("searching")
    results_loading_string = "<div class='results-loading'><img src='/assets/loading.gif'></img><div>"
    no_results_found_string = "<div class='results-loading'>Sorry, no results were found.</div>"


    lol = $("#js-search-input").val()
    res = @results
    #https://developers.google.com/youtube/2.0/developers_guide_protocol

    # Reset Searchs
    $("#videosearchresults").html(results_loading_string)
    $("#playlistsearchresults").html(results_loading_string)
    @dropdownResults
    $('.search-bar .search-results').css('height', window.innerHeight - 190)

    # Search Videos
    @searcher.searchYTVideo(lol, (items) =>
      if not items or items.length == 0
        $("#videosearchresults").html(no_results_found_string)
        return

      existing_playlist_youtube_ids = (item.attributes['mediaid'] for item in @playlist.get('plitems').models)
      unique_video_search_results = (item for item in items when item.mediaid not in existing_playlist_youtube_ids)[0..3]
      search_results_html = JST["search/searchitems"](items : unique_video_search_results)
      $("#videosearchresults").html(search_results_html)

      for item in unique_video_search_results
        $("#"+ item.jsid).data("yto", item)
    )

    # Search Playlists
    @searcher.searchYTPlaylist(lol, (items) =>
      if not items or items.length == 0
        $("#playlistsearchresults").html(no_results_found_string)
        return

      srhtml = JST["search/searchitems"](items : items)
      $("#playlistsearchresults").html(srhtml)
      for item in items
        $("#"+item.jsid).data("yto", item)
    )

  srkey: (e) =>
    ENTER_CODE = 13
    if e.which == ENTER_CODE
      e.preventDefault()
      this.srclick(e)

  srclick: (e) =>
    e.preventDefault()
    e.stopPropagation()
    item = $(e.currentTarget).data("yto")
    $(e.currentTarget).parent().remove()
    @searchYouTube(e)
    console.log(item)
    if item.type == "video" or item.type == "audio"
      @addAnItem(item)
    if item.type == "playlist"
      @searcher.getYTPlaylistItems(item, (items) => @addManyItems(items))


  addManyItems: (items) ->
    @playlist.add_search_items(items)
    $("#js-search-input").focus()
    $("#js-search-input").select()

  addAnItem: (item) ->
    @playlist.add_search_item(item)
    $("#js-search-input").focus()
    $("#js-search-input").select()

  change: ->
    console.log("change")

  select: ->
    console.log("select")

  dropdownResults: (e) ->
    if !$('.search-bar.open').is('*')
      $('.dropdown-toggle').dropdown('toggle')
