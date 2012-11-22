class PlaylistsController < ApplicationController
  respond_to :json

  def show
    pl = Playlist.where(:uuid => params[:id]).first
    pljson = pl.as_json
    pljson["plitems"] = pl.orderedplitems(@session)
    render :json => pljson
  end

  def create
    pl = Playlist.create
    render :json => pl
  end

  def update
    pl = Playlist.where(:uuid => params[:id]).first
    pl.update_attributes(params[:playlist])
    render :json => params[:playlist]
  end


end
