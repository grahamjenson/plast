class Plast.Models.Plitem extends Backbone.RelationalModel
  url: =>
    if @collection.playlist.get("readonly")
      return "/api/read_only_playlists/#{@collection.playlist.id}/read_only_plitems"
    else
      return "/api/playlists/#{@collection.playlist.id}/plitems"

  as_json: ->
    plitem = this
    return {
      mediaid: plitem.get("mediaid"),
      playername: plitem.get("playername"),
      title: plitem.get("title"),
      thumbnail: plitem.get("thumbnail"),
      length: plitem.get("length")
    }

  add_download_link: (success) ->
    if @get('playername') == 'youtube'
      @add_yt_dl_link(->
        success()
      )
    else
      if @get('playername') == 'soundcloud'
        @add_sc_dl_link(->
          success()
        )

  add_sc_dl_link: (success) ->
    SC.init()
    SC.get(this.get('mediaid'), (d) =>
      if d.downloadable
        @set("dllink", d.download_url)
        success()
      else
        @set("dlerror", "non-downloadable")
    )

  add_yt_dl_link: (success)->
    enqueURL = "/ytmp3/request"
    $.post(enqueURL, {"ytid" : this.get('mediaid')}, (data) =>
      @set("dllink", data.dlurl)
      success()
    ).error( =>
      @set("dlerror", "error")
    )