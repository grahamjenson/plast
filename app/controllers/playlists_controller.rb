class PlaylistsController < ApplicationController
  respond_to :json

  def assignSession(pl)
    if not pl.sessions.include? @session
      pl.playlist_sessions.create({session: @session})
    end
    return pl
  end

  def show
    pl = Playlist.where(:uuid => params[:id]).first
    assignSession(pl)
    render :json => pl
  end

  def create
    pl = Playlist.create
    assignSession(pl)
    render :json => pl
  end

  def update
    pl = Playlist.where(:uuid => params[:id]).first
    assignSession(pl)
    pl.update_attributes(params[:playlist])
    render :json => params[:playlist]
  end


end
