class Plast.Views.Search extends Backbone.View


  template: JST['playlists/search']

  events:
    'click .srlink' : 'srclick'
    'keydown .srlink' : 'srkey'
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

  refocusonsearch: ->

  searchyt: (event) =>
    event.preventDefault()
    #TODO make sure $("#searchresults") has been dropped

    if not $("#searchresults").parent().hasClass('open')
      $("#searchresults").parent().toggleClass('open')
    lol = $("#serchtext").val()
    res = @results
    #https://developers.google.com/youtube/2.0/developers_guide_protocol
    $("#searchresults").html("Waiting for results...")
    $.getJSON("https://gdata.youtube.com/feeds/api/videos?q=#{lol}&orderby=relevance&max-results=10&v=2&alt=jsonc", {}, (d) ->
      if not d.data.items
        $("#searchresults").html("No results")
        return
      for item in d.data.items
        res[item.id] = item
      srhtml = JST["playlists/searchresult"](items : d.data.items)
      $("#searchresults").html(srhtml)
    )

  srkey: (e) =>
    ENTER_CODE = 13
    if e.which == ENTER_CODE
      e.preventDefault()
      this.srclick(e)

  srclick: (e) =>
    e.preventDefault()
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
