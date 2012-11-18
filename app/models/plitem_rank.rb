class PlitemRank < ActiveRecord::Base
  belongs_to :plitem
  belongs_to :session
  attr_accessible :rank, :session, :plitem

  validates :rank, :presence => true

  validates_uniqueness_of :session_id, :scope => :plitem_id

  def rank=(attr_rank)
    if plitem and self.rank != attr_rank
      plitem.rating_dirty = true
      plitem.save()
    end
    write_attribute(:rank, attr_rank)
  end

end