class ReadOnlyPlitemsController < ApplicationController
  respond_to :json

  def index
    #get plitems
    pl = Playlist.find(params[:id])
    plitems = pl.aggregated_order
    render :json => plitems
  end

end