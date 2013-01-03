class Searcher

  youtubeplaylist_to_searchitem: (ytitem) ->
    sr = new SearchItem({
      type: 'playlist',
      title: ytitem.title,
      mediaid : ytitem.id,
      playername: "youtube",
      thumbnail: ytitem.thumbnail.sqDefault,
      size: ytitem.size,
      description: ytitem.description,
      uploader: ytitem.uploader,
      viewCount: ytitem.viewCount,
      updated: ytitem.updated
      }
    )

  youtubeitem_to_searchitem: (ytitem) ->
    sr = new SearchItem({
      type: 'video',
      title: ytitem.title,
      mediaid : ytitem.id,
      playername: "youtube",
      thumbnail: ytitem.thumbnail.sqDefault,
      duration: ytitem.duration,
      description: ytitem.description,
      uploader: ytitem.uploader,
      viewCount: ytitem.viewCount,
      uploaded: ytitem.uploaded
      }
    )

  check_ytitem: (ytitem) ->
    if not ytitem
      return false
    if not ytitem.status
      return true
    if not ytitem.thumbnail
      return false
    return true

  searchYTVideo: (text, callback) ->
    $.getJSON("https://gdata.youtube.com/feeds/api/videos?q=#{text}&orderby=relevance&max-results=10&v=2&alt=jsonc", {}, (d) =>
      if not d.data.items
        callback([])
      else
        callback((@youtubeitem_to_searchitem(yto) for yto in d.data.items when @check_ytitem(yto)))
    )

  searchYTPlaylist: (text, callback) ->
    $.getJSON("https://gdata.youtube.com/feeds/api/playlists/snippets?q=#{text}&orderby=relevance&max-results=5&v=2&alt=jsonc", {}, (d) =>
      if not d.data.items
        callback([])
      else
        callback((@youtubeplaylist_to_searchitem(yto) for yto in d.data.items))
    )

  getYTPlaylistItems: (searchItem, callback) ->
    $.getJSON("https://gdata.youtube.com/feeds/api/playlists/#{item.playlist.id}?alt=jsonc&v=2&max-results=50",
      {},
      (d) =>
        return ((@youtubeitem_to_searchitem(yto.video) for yto in d.data.items when @check_ytitem(yto)))
    )


window.Searcher = Searcher