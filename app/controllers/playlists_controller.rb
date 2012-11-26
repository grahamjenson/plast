class PlaylistsController < SharedPlaylistsController
  respond_to :json

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
    for pli in params[:plitems]
      begin
        plitem = Plitem.where(youtubeid: pli[:youtubeid], playlist_id: pl.id).first_or_create!(
          {
          playlist_id: pl.id,
          youtubeid: pli[:youtubeid],
          title: pli[:title],
          thumbnail: pli[:thumbnail],
          length: pli[:length],
          count: i
          }
        )
        plitem.find_create_rank(@session,i)
        i += 1
      rescue
        errors ||= []
        errors << "ERROR"
      end
    end
    render :json => {success: true}
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
    for index, pli in params[:plitems]
      begin
        plitem = Plitem.where(youtubeid: pli[:youtubeid], playlist_id: pl.id).first_or_create!(
          {
          playlist_id: pl.id,
          youtubeid: pli[:youtubeid],
          title: pli[:title],
          thumbnail: pli[:thumbnail],
          length: pli[:length],
          count: i+index.to_i
          }
        )
        plitem.find_create_rank(@session,i+index.to_i)
      rescue
        errors ||= []
        errors << "ERROR"
      end
    end
    if errors
      render :json => as_json_pl(pl)
    else
      render :json => {success: true}
    end
  end

end
