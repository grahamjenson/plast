class Plast.Views.Jumbo extends Backbone.View

  template: JST['jumbo']

  events: {
    "click #createbtnlink" : 'createNewPlaylist'
  }

  createNewPlaylist: ->
    console.log("NEWWW")


  constructor: (brouter) ->
    super()
    brouter.bind("all", (route, router) ->
      $('#jumbo').html(@jumbo.render().el))

  render: ->
    console.log("AsD:" + Backbone.history.fragment)
    if Backbone.history.fragment == ""
      this.grow()
    else
      this.shrink()

    $(@el).html(@template())
    this

  shrink: ->
    console.log("shrink")
    $("#jumbo").animate({'height': '200px'},600, "easeOutBounce" , -> $("#createbtn").hide())


  grow: ->
    console.log("grow")
    $("#jumbo").animate({'height': '300px'},600, "easeOutBounce" , ->
      $("#createbtn").show()
      $("#createbtn").click(-> Backbone.defaultrouter.navigate("playlist", {trigger: true}))
    )
