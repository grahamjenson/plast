class PlitemsController < ApplicationController

  respond_to :json
  INIT_RATING = 100

  def index
    pl = Playlist.where(:uuid => params[:playlist_id]).first
    plitems = pl.plitems.order(:rating).reverse()
    plitem = plitems.select{|x| x.rating > 0}
    render :json => plitems
  end

  def show
    pl = Playlist.where(:uuid => params[:playlist_id]).first
    pli = pl.plitems.select{|x| x.id == params[:id]}.first
    render :json => pli
  end

  def create
    pl = Playlist.where(:uuid => params[:playlist_id]).first
    pitem = pl.plitems.create({
      youtubeid: params[:youtubeid],
      title: params[:title],
      thumbnail: params[:thumbnail],
      length: params[:length],
      rating: INIT_RATING - pl.plitems.size
      })
    if pitem.save
      render :json => pitem
    else
      render :json => { :errors => pitem.errors.full_messages }, :status => 422
    end
  end

  def vote
    logger.debug("VOTING #{params}")
    pl = Playlist.where(:uuid => params[:playlist_id]).first
    votes = params[:votes]

    for plitem in pl.plitems do
      vote = votes["#{plitem.id}"]
      if vote
        votingAlgorithm(pl,plitem,vote.to_f)
      end
    end
    render :json => {success: "Votes counted"}
  end

  def votingAlgorithm(pl,plitem,vote)
    plitem.rating += (vote / pl.sessions.size())
    plitem.save()
  end
end
