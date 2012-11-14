class PlitemRank < ActiveRecord::Base
  belongs_to :plitem
  belongs_to :session
  attr_accessible :rank, :session, :plitem

  validates :rank, :presence => true

  validates_uniqueness_of :session_id, :scope => :plitem_id


end