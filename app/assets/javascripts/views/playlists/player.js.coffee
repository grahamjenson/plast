class Plast.Views.Player extends Backbone.View

  template: JST['playlists/playerhead']

  events:
    'click #back' : 'back'
    'click #play' : 'play'
    'click #forward' : 'forward'
    'click #pause' : 'pause'

  constructor: (playlist) ->
    super()
    @playlist = playlist


  render: ->
    $(@el).html(@template(plitem: @playlist))
    #Rendered the template
    params = { allowScriptAccess: "always"};
    atts = { id: "ytplayer" };
    ytid = "9bZkp7q19f0"
    swfobject.embedSWF("http://www.youtube.com/v/#{ytid}?version=3&enablejsapi=1&playerapiid=ytplayer", "ytplayer", "600", "400", "9.0.0", null, null, params, atts)
    this


  window.onYouTubePlayerReady = (id) ->
    console.log("onYouTubePlayerResadsadsady() Fired! #{id}");
    console.log(ytplayer)

  back: ->
    console.log("back")

  pause: ->
    console.log("pause")

  play: ->
    console.log("play")
    plitem = @playlist.getPlayableItems()[0]
    plitem.set("played", (new Date()).getTime())
    console.log(plitem)
    ytplayer.loadVideoById(plitem.get("youtubeid"))

  forward: ->
    console.log("forward")