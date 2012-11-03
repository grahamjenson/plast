class PlitemsController < ApplicationController

  respond_to :json

  def index
    pl = Playlist.where(:uuid => params[:playlist_id]).first
    render :json => pl.plitems
  end

  def show
    pl = Playlist.where(:uuid => params[:playlist_id]).first
    pli = pl.plitems.select{|x| x.id == params[:id]}.first
    render :json => pli
  end

  def create
    pl = Playlist.where(:uuid => params[:playlist_id]).first
    pitem = pl.plitems.create({youtubeid: params[:youtubeid]})
    if pitem.save
      render :json => pitem
    else
      render :json => { :errors => pitem.errors.full_messages }, :status => 422
    end
  end

end
