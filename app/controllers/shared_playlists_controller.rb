class SharedPlaylistsController < ApplicationController

  def as_json_pl(pl)
    pljson = pl.as_json
    pljson["plitems"] = pl.orderedplitems(@session)
    return pljson
  end

  def find_or_create_plitems(pl,plitems,initialRank)
    i = initialRank
    for pli in plitems
      begin
        plitem = Plitem.where(mediaid: pli[:mediaid], playlist_id: pl.id).first_or_create!(
          {
          playlist_id: pl.id,
          mediaid: pli[:mediaid],
          playername: pli[:playername],
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
    return errors
  end

  def branch
    pl = Playlist.create
    plitems = []
    if params[:plitems]
      params[:plitems].each{|index, pli| plitems[index.to_i] = pli}
      errors = find_or_create_plitems(pl,plitems,0)
      if errors
        render :json => {errors: errors}
      else
        render :json => as_json_pl(pl)
      end
    else
      render :json => as_json_pl(pl)
    end
  end

end
