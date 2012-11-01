class Playlist < ActiveRecord::Base
  #The id coming from backbone is the uuid here

  attr_accessible :uuid
  validates :uuid, :presence => true
  before_validation :generate_uuid

  has_many :plitems

  def generate_uuid
    self.uuid ||= SecureRandom.uuid
  end

  def as_json(options)
    jsond = super(options)
    #fix uuid
    jsond["id"] = uuid
    jsond.delete("uuid")

    #add plitems
    jsond["plitems"] = self.plitems
    return jsond
  end

end
