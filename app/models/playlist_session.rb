class PlaylistSession < ActiveRecord::Base
  belongs_to :playlist
  belongs_to :session
  attr_accessible :playlist, :session
end