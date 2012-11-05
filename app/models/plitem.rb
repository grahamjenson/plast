class Plitem < ActiveRecord::Base
  belongs_to :playlist

  attr_accessible :youtubeid, :title, :thumbnail, :length, :rating

  validates :youtubeid, :title, :playlist, :presence => true

  validate :unique_ytid

  def unique_ytid
    errors.add(:playlist, "Must be Unique") if playlist.plitems.find{|pli| pli.youtubeid == youtubeid}
  end
end
