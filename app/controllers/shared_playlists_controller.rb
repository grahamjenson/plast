class SharedPlaylistsController < ApplicationController

  def as_json_pl(pl)
    pljson = pl.as_json
    pljson["plitems"] = pl.orderedplitems(@session)
    return pljson
  end


  def branch
    pl = Playlist.create
    i = 0
    if params[:plitems]
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
    end
    render :json => as_json_pl(pl)
  end

end
