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

  soundclouditem_to_searchitem: (scitem) ->
    sr = new SearchItem({
      type: 'audio',
      title: scitem.title,
      mediaid : scitem.uri,
      playername: "soundcloud",
      duration: scitem.duration/1000,
      description: scitem.description,
      uploader: scitem.user.username,
      viewCount: scitem.playback_count,
      uploaded: scitem.created_at
      download_url: scitem.download_url
      }
    )
    sr.thumbnail = scitem.waveform_url if scitem.waveform_url
    sr.thumbnail = scitem.user.avatar_url if scitem.user.avatar_url
    sr.thumbnail = scitem.artwork_url if scitem.artwork_url
    return sr

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

  searchSoundCloudTracks: (searchText, callback) ->
    SC.init()
    SC.get('/tracks', { q: "#{searchText}", order: "hotness" }, (tracks) =>
      if tracks.errors or tracks.length == 0
        callback([])
      else
        callback((@soundclouditem_to_searchitem(track) for track in tracks)[0..3])
    );


window.Searcher = Searcher