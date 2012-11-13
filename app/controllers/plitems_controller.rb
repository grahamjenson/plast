class PlitemsController < ApplicationController

  respond_to :json
  INIT_RATING = 100
  before_filter :get_playlist

  def get_playlist
    @pl = Playlist.where(:uuid => params[:playlist_id]).first
  end

  def index
    #get plitems
    plitems = @pl.plitems

    #set rating with session information
    plitems.each{|pli| pli.setRatingForSession(@session)}
    plitems = plitems.sort{|pl1,pl2| pl1.rating - pl2.rating}
    logger.debug("INDEX #{plitems.map{|x| [x.title,x.rating]}}")

    #filter negative ratings, ensuring removed items do not return
    plitems = plitems.select{|x| x.rating >= 0}

    render :json => plitems
  end

  def show
    pli = @pl.plitems.select{|x| x.id == params[:id].to_i}.first
    render :json => pli
  end

  def create
    plsize = @pl.plitems.size()
    pitem = @pl.plitems.create({
      youtubeid: params[:youtubeid],
      title: params[:title],
      thumbnail: params[:thumbnail],
      length: params[:length],
      rating: plsize
      })

    prank = pitem.plitem_ranks.build(:session => @session, :rank => pitem.rating)

    if pitem.save
      render :json => pitem
    else
      render :json => { :errors => pitem.errors.full_messages }, :status => 422
    end
  end

  def reorder
    plitems = params[:order].map{|x| Plitem.find(x.to_i)}
    logger.debug("REORDER #{plitems}")
    i = 0
    for plitem in plitems do
      plrank = plitem.findOrCreatePlitemRank(@session)
      plrank.rank = i
      plrank.save()
      i += 1
    end
    render :json => {success: "reordered"}
  end

  def remove
    pli = @pl.plitems.select{|x| x.id == params[:id].to_i}.first
    plrank = pli.findOrCreatePlitemRank(@session)
    plrank.rank = -1
    plrank.save()
    render :json => {success: "removed"}
  end
end
