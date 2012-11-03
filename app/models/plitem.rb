class Plitem < ActiveRecord::Base
  attr_accessible :youtubeid
  validates :youtubeid, :presence => true

  belongs_to :playlist
end
