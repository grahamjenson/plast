class Session < ActiveRecord::Base
  #The id coming from backbone is the uuid here

  attr_accessible :data, :session_id

end
