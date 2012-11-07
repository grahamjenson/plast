class Session < ActiveRecord::Base
  #The id coming from backbone is the uuid here

  attr_accessible :data

  has_many :playlist_sessions

  has_many :playlists, :through => :playlist_sessions
end
