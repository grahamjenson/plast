class PlaylistSession < ActiveRecord::Base
  belongs_to :playlist
  belongs_to :session
end