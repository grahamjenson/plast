class Session < ActiveRecord::Base
  #The id coming from backbone is the uuid here

  attr_accessible :data, :session_id, :updated_at
  has_many :plitem_ranks, :dependent => :destroy

  def clean?
    self.updated_at > 24.hours.ago
  end
end
