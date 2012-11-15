class ReadOnlyPlaylistsController < ApplicationController
  respond_to :json

  def show
    pl = Playlist.find(params[:id])
    pljson = pl.to_json
    #hide uuid
    plson[:id] = pl.id
    render :json => pl
  end

end