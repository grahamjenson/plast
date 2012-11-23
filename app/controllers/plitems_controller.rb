class PlitemsController < ApplicationController

  respond_to :json
  before_filter :get_playlist

  def get_playlist
    @pl = Playlist.where(:uuid => params[:playlist_id]).first
  end

  def remove
    pli = @pl.plitems.select{|x| x.id == params[:id].to_i}.first
    plrank = pli.find_plitem_rank(@session)
    plrank.rank = -1
    plrank.save()
    render :json => {success: "removed"}
  end
end
