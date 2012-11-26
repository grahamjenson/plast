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
    #adds and ranks all
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
      plitem.find_create_rank(@session,i)
      i += 1
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
      plitem = Plitem.where(youtubeid: pli[:youtubeid], playlist_id: pl.id).first_or_create!(
        {
        playlist_id: pl.id,
        youtubeid: pli[:youtubeid],
        title: pli[:title],
        thumbnail: pli[:thumbnail],
        length: pli[:length],
        }
      )
      plitem.find_create_rank(@session,i+index.to_i)
    end

    render :json => {success: true}
  end

  def branch
    pl = Playlist.create
    i = 0
    for index, pli in params[:plitems]
      plitem = Plitem.where(youtubeid: pli[:youtubeid], playlist_id: pl.id).first_or_create!(
        {
        playlist_id: pl.id,
        youtubeid: pli[:youtubeid],
        title: pli[:title],
        thumbnail: pli[:thumbnail],
        length: pli[:length],
        }
      )
      plitem.find_create_rank(@session,i+index.to_i)
    end

    render :json => as_json_pl(pl)
  end
end
