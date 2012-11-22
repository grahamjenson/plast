require 'spec_helper'
require 'session_helper'
require 'json_helper'

describe PlitemsController do
  include SessionHelper
  include JSONHelper

  before :each do
    @pl = Playlist.create()
    @plitem1 = {
      :playlist_id => @pl.uuid,
      youtubeid: "1",
      title: "1",
      thumbnail: "1",
      length: 1,
      }
    @plitem2 = {
      :playlist_id => @pl.uuid,
      youtubeid: "2",
      title: "2",
      thumbnail: "2",
      length: 2,
      }
    @plitem3 = {
      :playlist_id => @pl.uuid,
      youtubeid: "3",
      title: "3",
      thumbnail: "3",
      length: 3,
      }
  end

  describe "POST create" do
    it "will add created item to playlist" do
      set_session("a")
      post :create, @plitem1
      @pl.reload()
      @pl.plitems.length.should eq 1
    end

    it "will build and set rank incrementally" do
      session = set_session("a")
      post :create, @plitem1
      json = get_response
      rank = Plitem.find(json["id"]).find_plitem_rank(session)
      rank.rank.should eq 0

      post :create, @plitem2
      json = get_response
      rank = Plitem.find(json["id"]).find_plitem_rank(session)
      rank.rank.should eq 1
    end

    it "will not create plitem with same youtube id" do
      set_session("a")
      post :create, @plitem1
      response.should be_success
      post :create, @plitem1
      response.should_not be_success
      json = get_response
      json["errors"].should_not eq nil
    end

  end

  describe "GET index" do
    it "will return the plitems for a playlist" do
      set_session("a")
      post :create, @plitem1
      post :create, @plitem2
      get :index, :playlist_id => @pl.uuid
      json = get_response
      json.length.should eq 2
      json[0]["title"].should eq "1"
      json[1]["title"].should eq "2"
    end

    it "will return the plitems when another session adds" do
      set_session("a")
      post :create, @plitem1

      set_session("b")
      post :create, @plitem2

      set_session("a")
      get :index, :playlist_id => @pl.uuid
      json = get_response
      json.length.should eq 2
      json[0]["title"].should eq "1"
      json[1]["title"].should eq "2"

    end

    it "will add ranks to when fetched " do
      set_session("a")
      post :create, @plitem1
      post :create, @plitem2

      PlitemRank.all.length.should eq 2

      set_session("b")
      get :index, :playlist_id => @pl.uuid
      PlitemRank.all.length.should eq 4
      json = get_response
    end

  end

  describe "POST reorder" do
    it "will reorder for one session" do
      sessiona = set_session("a")
      post :create, @plitem1
      pli1 = Plitem.find(get_response()["id"])
      post :create, @plitem2
      pli2 = Plitem.find(get_response()["id"])

      pli1.find_plitem_rank(sessiona).rank.should eq 0
      pli2.find_plitem_rank(sessiona).rank.should eq 1

      post :reorder, :playlist_id => @pl.uuid, :order => [pli2.id, pli1.id]
      pli1.reload
      pli2.reload
      pli1.find_plitem_rank(sessiona).rank.should eq 1
      pli2.find_plitem_rank(sessiona).rank.should eq 0
    end
  end
end
