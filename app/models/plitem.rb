class Plitem < ActiveRecord::Base
  attr_accessible :url
  validates :url, :presence => true
  validates_formatting_of :url, :using => :url, :message => 'is completely unacceptable'

  belongs_to :playlist
end
