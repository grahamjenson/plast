class Plitem < ActiveRecord::Base
  belongs_to :playlist

  attr_accessible :youtubeid, :title, :thumbnail, :length

  validates :youtubeid, :title, :playlist, :presence => true

  validate :unique_ytid

  has_many :plitem_ranks

  validate :has_plitem_ranks?

  def has_plitem_ranks?
    errors.add(:plitem_ranks, "Model must have one rank.") if self.plitem_ranks.blank?
  end

  def unique_ytid
    errors.add(:playlist, "Must be Unique") if playlist.plitems.find{|pli| pli != self and pli.youtubeid == youtubeid}
  end

  def find_plitem_rank(session)
    plitem_ranks.select{|x| x.session_id == session.id}.first
  end
  #get the rank of the item
  def rank(session = nil)
    if session
      #if there is a session we return the rank
      plrank = self.find_plitem_rank(session)
      if plrank
        return plrank.rank
      else
        return nil
      end
    else
      #no session return the average rank
      return aggregateRank
    end
  end


  def aggregateRank
    #main ranking function
    removes = plitem_ranks.select{|r| r.rank < 0}.size()
    ranks =  plitem_ranks.select{|r| r.rank >= 0}.map{|r| r.rank}
    total = plitem_ranks.size

    #25% of pple want it removed it is removed, can come back with more pple
    if removes > (0.25 * total)
      return -1
    else
      return ranks.sum / total #this takes into account the removes
    end
  end

  def buildRank(session,rank)
    return plitem_ranks.build(:session => session, :rank => rank)
  end


  def as_json(options)
    jsond = super(options)
    #fix uuid
    jsond["playlist_id"] = playlist.uuid
    return jsond
  end
end
