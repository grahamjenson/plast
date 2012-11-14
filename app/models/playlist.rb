class Playlist < ActiveRecord::Base
  #The id coming from backbone is the uuid here

  attr_accessible :uuid
  validates :uuid, :presence => true
  before_validation :generate_uuid

  has_many :plitems

  def orderedplitems(session)
    #THIS METHOD IS VERRY INEFFICIENT
    #get plitems
    plis = self.plitems
    #seperate into two lists those that have been ranked and those that havnt
    beenRanked = plis.select{ |x| x.rank(session) }
    notRanked = plis.select{ |x| not x.rank(session) }

    #filter already removed or aggregated to be removed
    notRemoved = beenRanked.select{|x| x.rank(session) >= 0}
    notRanked = notRanked.select{|x| x.rank >= 0}

    #sort both lists
    notRanked = notRanked.sort{ |pl1,pl2| pl1.rank - pl2.rank}
    notRemoved = notRemoved.sort{ |pl1,pl2| pl1.rank(session) - pl2.rank(session)}

    #create ranks for not ranked
    i = beenRanked.size()
    for nr in notRanked do
      br = nr.buildRank(session,i)
      br.save()
      i += 1
    end

    return notRemoved + notRanked
  end

  def generate_uuid
    self.uuid ||= rand(36**8).to_s(36)
  end

  def as_json(options)
    jsond = super(options)
    #fix uuid
    jsond["id"] = uuid
    jsond.delete("uuid")
    return jsond
  end

end
