require 'spec_helper'

describe PlitemsController do
  before :each do
    @playlist = Playlist.create()
  end

  it "will create a plitem" do
    post :create
    puts responce
  end

end
