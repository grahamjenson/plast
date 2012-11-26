class Playlist < ActiveRecord::Base
  #The id coming from backbone is the uuid here

  attr_accessible :uuid
  validates :uuid, :presence => true
  before_validation :generate_uuid


  has_many :plitems
  has_many :plitem_ranks, :through => :plitems

  def create_or_get_plitem(session, ytitem)
    pitem = self.plitems.where(youtubeid: ytitem[:youtubeid]).first
    if not pitem
      pitem = self.plitems.create({
        youtubeid: ytitem[:youtubeid],
        title: ytitem[:title],
        thumbnail: ytitem[:thumbnail],
        length: ytitem[:length],
        })
    end
    if not pitem.save()
      return nil
    end
    prank = pitem.find_plitem_rank(session)
    if not prank
      prank = pitem.buildRank(session,ytitem[:rank])
    prank.rank = ytitem[:rank]
    end

    if not prank.save()
      return nil
    end
    return pitem
  end


  def aggregated_order
    plis_to_be_ranked = plitems.map{|x| {plitem: x, rank: x.rank} }
    #filter those out removed
    plis_to_be_ranked = plis_to_be_ranked.select{|x| x[:rank] >= 0}
    #sort based on rank
    plis_to_be_ranked = plis_to_be_ranked.sort{ |pl1,pl2| pl1[:rank] - pl2[:rank]}

    plis_to_be_ranked = plis_to_be_ranked.map{|x| x[:plitem]}
  end

  def orderedplitems(session)
    #THIS METHOD IS VERRY INEFFICIENT
    #ITEMS THAT HAVE BEEN RANKED
    all_pli_ranks = self.plitem_ranks.where(:session_id => session.id) #all ranks
    ranks_notRemoved = all_pli_ranks.select{|x| x.rank >= 0} #all non removed ranks
    logger.debug("PLAYLIST ITEM 0")

    plitems_notRemoved = ranks_notRemoved.sort{ |pl1,pl2| pl1.rank - pl2.rank}.map{|x| x.plitem} #
    logger.debug("PLAYLIST ITEM 1")
    if all_pli_ranks.size() == plitems.size() #if ranked everything
      logger.debug("PLAYLIST BROKE EARLY")
      return plitems_notRemoved
    end

    logger.debug("PLAYLIST KEPT GOING") #Rank all items not ranked as the aggregate rank

    all_pli_rank_ids = all_pli_ranks.map{|x| x.plitem_id}
    plis_notRanked = plitems.select{|x| not all_pli_rank_ids.include?(x.id) }
    #be so much easier with python pairs!!
    plis_to_be_ranked = plis_notRanked.map{|x| {plitem: x, rank: x.rank} }

    #assign those ranked <0 to that
    for rem in plis_to_be_ranked.select{|x| x[:rank] < 0}
      br = rem[:plitem].buildRank(session, rem[:rank])
      br.save()
    end

    #filter those out removed
    plis_to_be_ranked = plis_to_be_ranked.select{|x| x[:rank] >= 0}
    #sort based on rank
    plis_to_be_ranked = plis_to_be_ranked.sort{ |pl1,pl2| pl1[:rank] - pl2[:rank]}

    plis_to_be_ranked = plis_to_be_ranked.map{|x| x[:plitem]}

    #create ranks for not ranked based on order
    i = all_pli_ranks.size()
    for nr in plis_to_be_ranked do
      br = nr.buildRank(session,i)
      br.save()
      i += 1
    end

    return plitems_notRemoved + plis_to_be_ranked
  end

  def generate_uuid
    self.uuid ||= rand(36**8).to_s(36)
  end

  def as_json(options = {})
    jsond = super(options)
    #fix uuid
    jsond["id"] = uuid
    jsond["read_only_id"] = self.id

    jsond.delete("uuid")
    return jsond
  end

end
