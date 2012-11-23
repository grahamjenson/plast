class PlaylistsController < ApplicationController
  respond_to :json

  def as_json_pl(pl)
    pljson = pl.as_json
    pljson["plitems"] = pl.orderedplitems(@session)
    return pljson
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
    for pli in params[:plitems]
      plitem = Plitem.where(youtubeid: pli[:youtubeid], playlist_id: pl.id).first_or_create!(
        {
        playlist_id: pl.id,
        youtubeid: pli[:youtubeid],
        title: pli[:title],
        thumbnail: pli[:thumbnail],
        length: pli[:length],
        }
      )

      prank = plitem.find_plitem_rank(@session)
      if not prank
        prank = plitem.buildRank(@session,i)
      end
      prank.rank=i
      prank.save!()
      i += 1
    end
    render :json => as_json_pl(pl)
  end


end
