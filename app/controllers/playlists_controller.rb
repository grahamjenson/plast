class PlaylistsController < ApplicationController
  respond_to :json

  def show
    render :json => Playlist.where(:uuid => params[:id]).first
  end

  def create
    render :json => Playlist.create
  end

  def update
    pl = Playlist.where(:uuid => params[:id]).first
    pl.update_attributes(params[:playlist])
    render :json => params[:playlist]
  end

end
