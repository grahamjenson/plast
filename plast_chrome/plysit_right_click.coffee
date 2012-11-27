class PlysitPlugin
  constructor: ->
    chrome.tabs.onCreated.addListener(
      =>
        this.createContextMenu()
    )

    chrome.tabs.onRemoved.addListener(
      =>
        this.createContextMenu()
    )

    chrome.tabs.onUpdated.addListener(
      =>
        this.createContextMenu()
    )


  plysit_url: (url) ->
    /.*:\/\/.*plysit.com\/playlist\/.*/.test(url)

  targetPatterns: ['*://*.youtube.com/watch?*v=*','*://*.youtu.be/*']

  createContextMenu: ->
    chrome.contextMenus.removeAll()

    #chrome.contextMenus.create(
    #      title: "Add to new Plysit"
    #      contexts: ["link"]
    #      targetUrlPatterns: @targetPatterns
    #      onclick: (info) => @createNewPlysit(info.linkUrl)
    #    )

    __this = this
    @forEachTab((t) =>
      if @plysit_url(t.url)
        chrome.contextMenus.create(
          title: "Add to #{t.url}"
          contexts: ["link"]
          targetUrlPatterns: @targetPatterns
          onclick: (info) => __this.addToPlysit(t.url,info.linkUrl, t.id)
        )
    )

  youtube_parser: (url) ->
    regExp = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]*).*/;
    match = url.match(regExp);
    if (match&&match[7].length==11)
        return match[7]
    else
        return null


  createNewPlysit: (yturl) ->
    ytid = @youtube_parser(yturl)
    if ytid
      $.getJSON("https://gdata.youtube.com/feeds/api/videos/#{ytid}?alt=jsonc&v=2", (d) ->
        console.log(d.data)
        )


  addToPlysit: (plyurl, yturl, tabid) ->
    ytid = @youtube_parser(yturl)
    if ytid
      $.getJSON("https://gdata.youtube.com/feeds/api/videos/#{ytid}?alt=jsonc&v=2", (d) ->
        chrome.tabs.sendMessage(tabid,{type: "plysit_plugin", ytitem: d.data})
      )

  forEachTab: (fun) ->
    chrome.windows.getAll((w) ->
      for win in w
        chrome.tabs.getAllInWindow(win.id, (tabs) ->
          (fun(t) for t in tabs)
        )
    )

window.plysit_plugin = new PlysitPlugin()
window.plysit_plugin.createContextMenu()
