class Plitem < ActiveRecord::Base
  belongs_to :playlist

  attr_accessible :youtubeid, :title, :thumbnail, :length, :rating

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

  def aggregateRating
    #main ranking function
    removes = plitem_ranks.select{|r| r < 0}.size()

    ranks = plitem_ranks.select{|r| r >= 0}.each{|r| r.rank}

    total = plitem_ranks.size

    #25% of pple want it removed it is removed
    if removes > (0.25 * total)
      return -1
    else
      return ranks.sum / ranks.size
    end
  end

  def setAggregateRating
    self.rating = aggregateRating()
  end

  def findOrCreatePlitemRank(session)
    plrank = plitem_ranks.where(:session_id => session.id).first
    if not plrank
      plrank = plitem_ranks.create(:session => session, :rank => aggregateRating())
    end
    return plrank
  end

  def setRatingForSession(session)
    plrank = findOrCreatePlitemRank(session)
    self.rating = plrank.rank
  end

  def as_json(options)
    jsond = super(options)
    #fix uuid
    jsond["playlist_id"] = playlist.uuid
    return jsond
  end
end
