class PlaylistsController < SharedPlaylistsController
  respond_to :json

  def self.clean
    for pl in Playlist.all.last_accessed
    end
  end

  def show
    pl = Playlist.where(:uuid => params[:id]).first
    render :json => as_json_pl(pl)
  end

  def create
    pl = Playlist.create
    render :json => as_json_pl(pl)
  end

  def update
    pl = Playlist.where(:uuid => params[:id]).first
    i = 0
    #adds and ranks all
    if params[:plitems]
      errors = find_or_create_plitems(pl,params[:plitems],i)
      if errors
        render :json => as_json_pl(pl)
      else
        render :json => as_json_pl(pl)
      end
    else
      render :json => as_json_pl(pl)
    end
  end

  def remove
    plitem = Plitem.find(params[:plitem_id])
    prank = plitem.find_plitem_rank(@session)
    prank.rank = -1
    prank.save()
    render :json => {success: true}
  end

  def add_plitems
    pl = Playlist.where(:uuid => params[:id]).first
    i = pl.plitems.size()
    plitems = []
    if params[:plitems]
      params[:plitems].each{|index, pli| plitems[index.to_i] = pli}
      errors = find_or_create_plitems(pl,plitems,i)
      if errors
        render :json => as_json_pl(pl)
      else
        render :json => as_json_pl(pl)
      end
    else
      render :json => as_json_pl(pl)
    end
  end

end
