require 'spec_helper'
require 'session_helper'

describe PlaylistsController do
  include SessionHelper

  describe "GET create" do
    it "will return a playlist with uuid" do
      set_session("a")
      get :create
      res = ActiveSupport::JSON.decode(response.body)
      res["id"].should_not eq nil
      res["id"].length.should eq 8
    end
  end

  describe "GET show" do
    it "will return the playlist with right uuid" do
      pl = Playlist.create()
      uuid = pl.uuid
      set_session("a")
      get :show, id: uuid
      res = ActiveSupport::JSON.decode(response.body)
      res["id"].should eq uuid
    end

    it "will return the playlists proper id for readonly" do
      pl = Playlist.create()
      uuid = pl.uuid
      set_session("a")
      get :show, id: uuid
      res = ActiveSupport::JSON.decode(response.body)
      res["id"].should eq uuid
    end
  end

end
