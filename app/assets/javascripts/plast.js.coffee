
window.Plast =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    Backbone.defaultrouter = new Plast.Routers.Playlists()
    Backbone.history.start({pushState: true})

String::trunc = (n) ->
  sb = this.substr(0,n)
  return sb

Number::truncate = ->
  this | 0

Number::pad = (size) ->
  s = "000000000" + this;
  return s.substr(s.length-size);

Number::toMinSec = ->
  sb = "#{(this / 60).truncate()}:#{(this % 60).truncate().pad(2) }"

$(document).ready ->
  Plast.init()
