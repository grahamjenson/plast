class Plitem < ActiveRecord::Base
  attr_accessible :youtubeid, :title, :thumbnail, :length, :rating
  validates :youtubeid, :title, :presence => true

  belongs_to :playlist
end
