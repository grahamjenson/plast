
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

Number::addCommas = ->
  nStr = "#{this}";
  x = nStr.split('.');
  x1 = x[0];
  if  x.length > 1
    x2 = '.#{x[1]}'
  else
    x2 = ''

  rgx = /(\d+)(\d{3})/;
  while rgx.test(x1)
    x1 = x1.replace(rgx, '$1' + ',' + '$2');
  return x1 + x2;

window.downloadURL = (url) ->
  iframe
  hiddenIFrameID = 'hiddenDownloader';
  iframe = document.getElementById(hiddenIFrameID);
  if (iframe == null)
    iframe = document.createElement('iframe');
    iframe.id = hiddenIFrameID;
    iframe.style.display = 'none';
    document.body.appendChild(iframe);
  iframe.src = url;


window.fireclick = (elem) ->
  if typeof elem == "string"
    elem = document.getElementById(elem);

  if not elem
    console.log("no link")
    return;

  if document.dispatchEvent
    oEvent = document.createEvent( "MouseEvents" );
    oEvent.initMouseEvent("click", true, true,window, 1, 1, 1, 1, 1, false, false, false, false, 0, elem);
    elem.dispatchEvent( oEvent );

  else
    if document.fireEvent
      elem.click();


$(document).ready ->
  Plast.init()
