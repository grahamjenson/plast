window.unique_counter = 1
window.unqueID = ->
  unique_counter += 1
  return "id#{unique_counter}"

class SearchItem
  constructor: (options) ->
    @type = options.type
    @title = options.title
    @mediaid = options.mediaid
    @playername = options.playername
    @description = options.description
    @duration = options.duration
    @thumbnail = options.thumbnail
    @uploader = options.uploader
    @viewCount = options.viewCount
    @size = options.size
    @uploaded = options.uploaded
    @updated = options.updated
    @jsid = unqueID()

window.SearchItem = SearchItem