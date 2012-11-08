class PlaylistsController < ApplicationController
  respond_to :json
  before_filter :get_update_session

  def get_update_session
    sid = request.session_options[:id]
    @session = Session.where(:session_id => sid).first
    logger.debug "SESSION #{@session}"
  end

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
