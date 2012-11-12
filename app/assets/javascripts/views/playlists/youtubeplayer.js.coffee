class Plast.Views.YoutubePlayer extends Backbone.View


  initialize: ->
    @ytplayer = this.model
    $("#show-video-btn").click(this.toggleVideo)
    @lock = false
    @top = true
    @botpos = {"margin-top" :'0'}

    @minWidth = 320
    @maxWidth = 1080
    @aspect = 0.609375
    @ytplayer.bind("change:state", (model,state) =>
      if state == Plast.Models.YTPlayer.READY
        this.resizePlayer()
    )

    @playerSelector = "#playerwrapper"

    $(window).resize(this.resizePlayer)

  resizePlayer: =>

    divWidth = parseInt($('#show-video-btn').width())
    newheight =
    console.log("resize #{divWidth}")

    #REFACTOR
    if divWidth >= @minWidth and divWidth <= @maxWidth
      @ytplayer.setSize(divWidth,divWidth*@aspect)
    else if divWidth < @minWidth
      @ytplayer.setSize(@minWidth,@minWidth*@aspect)
    else if divWidth > @maxWidth
      @ytplayer.setSize(@maxWidth,@maxWidth*@aspect)
    if @top
      $(@playerSelector).css({"margin-top" : "#{this.shrinkTo()}px"})

  shrinkTo: ->
    return -@ytplayer.height()-12

  toggleVideo: =>
    return if @lock
    console.log("toggle")
    @lock = true
    if @top
      this.toBottom()
    else
      this.toTop()

  toBottom: ->
    complete = => @lock = false; @top = not @top
    $(@playerSelector).animate(@botpos, complete)
      #REFACTOR change text and icons
    $("#show-video-btn").html('
        <i class="icon-chevron-up icon-white pull-left"></i>
        Hide Video
        <i class="icon-chevron-up icon-white pull-right"></i>')

  toTop: ->
    complete = => @lock = false; @top = not @top
    $(@playerSelector).animate({"margin-top" : "#{this.shrinkTo()}px"}, complete)
      #REFACTOR change text and icons HACY
    $("#show-video-btn").html('
        <i class="icon-chevron-down icon-white pull-left"></i>
        Show Video
        <i class="icon-chevron-down icon-white pull-right"></i>')

  render: ->
    console.log("youtubeplayer controller")
