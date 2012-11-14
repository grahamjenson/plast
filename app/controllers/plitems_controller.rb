class PlitemsController < ApplicationController

  respond_to :json
  INIT_RATING = 100
  before_filter :get_playlist

  def get_playlist
    @pl = Playlist.where(:uuid => params[:playlist_id]).first
  end

  def index
    #get plitems
    plitems = @pl.orderedplitems(@session)
    render :json => plitems
  end

  def show
    pli = @pl.plitems.select{|x| x.id == params[:id].to_i}.first
    render :json => pli
  end

  def create
    #check if it exists
    pitem = @pl.plitems.where(youtubeid: params[:youtubeid]).first
    if not pitem
      pitem = @pl.plitems.create({
        youtubeid: params[:youtubeid],
        title: params[:title],
        thumbnail: params[:thumbnail],
        length: params[:length],
        })
    end

    prank = pitem.buildRank(@session,@pl.plitems.size())

    if pitem.save
      prank.save()
      render :json => pitem
    else
      render :json => { :errors => pitem.errors.full_messages }, :status => 422
    end
  end

  def reorder
    #If the session has a plitem it has a rank
    plitems = params[:order].map{|x| Plitem.find(x.to_i)}
    logger.debug("REORDER #{plitems}")
    i = 0
    for plitem in plitems do
      plrank = plitem.find_plitem_rank(@session)
      plrank.rank = i
      plrank.save()
      i += 1
    end
    render :json => {success: "reordered"}
  end

  def remove
    pli = @pl.plitems.select{|x| x.id == params[:id].to_i}.first
    plrank = pli.find_plitem_rank(@session)
    plrank.rank = -1
    plrank.save()
    render :json => {success: "removed"}
  end
end
