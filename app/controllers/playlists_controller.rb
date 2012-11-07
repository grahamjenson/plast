class PlaylistsController < ApplicationController
  respond_to :json
  before_filter :get_update_session

  def get_update_session
    sid = request.session_options[:id]
    @session = Session.where(:session_id => sid).first
    logger.debug "SESSION #{@session}"
  end

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
