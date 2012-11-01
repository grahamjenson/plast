class PlitemsController < ApplicationController

  respond_to :json

  def create
    pl = Playlist.where(:uuid => params[:uuid]).first
    pitem = pl.plitems.create({url: params[:url]})
    if pitem.save
      render :json => pitem
    else
      render :json => { :errors => pitem.errors.full_messages }, :status => 422
    end
  end

end
