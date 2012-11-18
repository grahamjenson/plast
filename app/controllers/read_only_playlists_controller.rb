class ReadOnlyPlaylistsController < ApplicationController
  respond_to :json

  def show
    pl = Playlist.find(params[:id])
    plson = pl.as_json({})
    #hide uuid
    plson["id"] = pl.id.to_s
    render :json => plson
  end

end