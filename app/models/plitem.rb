class Plitem < ActiveRecord::Base
  REMOVAL_RATE = 0.25
  MAX_ITEMS = 100
  belongs_to :playlist

  attr_accessible :youtubeid, :title, :thumbnail, :length, :rating, :rating_dirty, :playlist_id, :count

  validates :youtubeid, :title, :playlist, :presence => true

  validate :unique_ytid

  has_many :plitem_ranks

  #validate :has_plitem_ranks?
  attr_accessor :count

  validates :count, :presence => true

  before_save :default_values

  validate :plitems_count_within_bounds?, :on => :create

  def plitems_count_within_bounds?
    errors.add(:playlist, "Too many plitems") if count >= Plitem::MAX_ITEMS
  end

  def default_values
    self.rating_dirty = true if self.rating_dirty == nil
  end

  def has_plitem_ranks?
    errors.add(:plitem_ranks, "Model must have one rank.") if self.plitem_ranks.blank?
  end

  def unique_ytid
    errors.add(:playlist, "Must be Unique") if playlist.plitems.find{|pli| pli != self and pli.youtubeid == youtubeid}
  end

  def find_create_rank(session,rank)
    prank = self.find_plitem_rank(session)
    if not prank
      prank = self.buildRank(session,rank)
    end
    prank.rank = rank
    prank.save()
  end

  def find_plitem_rank(session)
    plitem_ranks.where(:session_id => session.id, :plitem_id => self.id).first
  end

  #If session then return either number, or nil
  #session = nil then aggregateRank
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

  def getAllRemovalPlitemRanks
    plitem_ranks.all(:conditions => ["plitem_ranks.rank < 0"])
  end

  def getAllPositiveRanks
    plitem_ranks.all(:conditions => ["plitem_ranks.rank >= 0"])
  end

  def aggregateRank
    if self.rating_dirty
      #main ranking function
      removes = getAllRemovalPlitemRanks.size()
      ranks =  getAllPositiveRanks.map{|r| r.rank}
      total = ranks.size + removes

      #25% of pple want it removed it is removed, can come back with more pple
      ret = 0
      if removes >= (Plitem::REMOVAL_RATE * total)
        ret = -1
      else
        ret = (1.0* ranks.sum) / total #this takes into account the removes
      end
      self.rating = ret
      self.rating_dirty = false
      self.save()
    end
    return self.rating
  end

  def buildRank(session,rank)
    self.rating_dirty = true
    self.save()
    return plitem_ranks.build(:session => session, :rank => rank)
  end


  def as_json(options)
    jsond = super(options)
    #fix uuid
    #jsond["playlist_id"] = playlist.uuid
    jsond.delete("playlist_id")
    return jsond
  end
end
