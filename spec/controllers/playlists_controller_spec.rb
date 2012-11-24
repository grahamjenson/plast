require 'spec_helper'
require 'session_helper'
require 'json_helper'


describe PlaylistsController do
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

  describe "POST update" do

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


    it "will reorder for one session" do
      set_session("a")
      post :create, @plitem1
      pli1 = Plitem.find(get_response()["id"])
      post :create, @plitem2
      pli2 = Plitem.find(get_response()["id"])

      get :index, :playlist_id => @pl.uuid
      json = get_response
      json[0]["id"].should eq pli1.id
      json[1]["id"].should eq pli2.id

      post :reorder, :playlist_id => @pl.uuid, :order => [pli2.id, pli1.id]
      get :index, :playlist_id => @pl.uuid
      json = get_response
      json[0]["id"].should eq pli2.id
      json[1]["id"].should eq pli1.id
    end

    it "will reorder items for a new sessions" do
      set_session("a")
      post :create, @plitem1
      pli1 = Plitem.find(get_response()["id"])
      post :create, @plitem2
      pli2 = Plitem.find(get_response()["id"])
      post :reorder, :playlist_id => @pl.uuid, :order => [pli2.id, pli1.id]

      set_session("b")
      get :index, :playlist_id => @pl.uuid
      json = get_response
      json[0]["id"].should eq pli2.id
      json[1]["id"].should eq pli1.id
    end

    it "will not change someone elses order" do
      set_session("a")
      post :create, @plitem1
      pli1 = Plitem.find(get_response()["id"])
      post :create, @plitem2
      pli2 = Plitem.find(get_response()["id"])
      post :create, @plitem3
      pli3 = Plitem.find(get_response()["id"])


      set_session("b")
      get :index, :playlist_id => @pl.uuid
      post :reorder, :playlist_id => @pl.uuid, :order => [pli3.id, pli2.id, pli1.id]

      get :index, :playlist_id => @pl.uuid
      json = get_response
      json[0]["id"].should eq pli3.id
      json[1]["id"].should eq pli2.id
      json[2]["id"].should eq pli1.id

      set_session("a")
      get :index, :playlist_id => @pl.uuid
      json = get_response
      json[0]["id"].should eq pli1.id
      json[1]["id"].should eq pli2.id
      json[2]["id"].should eq pli3.id

    end

    it "will average orders of two sessions for a new session" do
      set_session("a")
      post :create, @plitem1
      pli1 = Plitem.find(get_response()["id"])
      post :create, @plitem2
      pli2 = Plitem.find(get_response()["id"])
      post :create, @plitem3
      pli3 = Plitem.find(get_response()["id"])

      #pli1, pli2, pli3 is 0,1,2

      set_session("b")
      get :index, :playlist_id => @pl.uuid
      post :reorder, :playlist_id => @pl.uuid, :order => [pli3.id, pli1.id, pli2.id]
      #pli1, pli2, pli3 is 1,2,0


      set_session("c")
      #Ranks should be
      #pli1, pli2, pli3 is 1,3,2
      get :index, :playlist_id => @pl.uuid
      json = get_response
      json[0]["id"].should eq pli1.id
      json[1]["id"].should eq pli3.id
      json[2]["id"].should eq pli2.id
    end

        it "will remove item from playlist when requested" do
      set_session("a")
      post :create, @plitem1
      pli1 = Plitem.find(get_response()["id"])
      post :create, @plitem2
      pli2 = Plitem.find(get_response()["id"])

      post :remove, :playlist_id => @pl.uuid, :id => pli1.id
      get :index, :playlist_id => @pl.uuid
      json = get_response
      json[0]["id"].should eq pli2.id
      json.length.should eq 1
    end

    it "will not remove item from  someone elses playlist if they have it" do
      set_session("a")
      post :create, @plitem1
      pli1 = Plitem.find(get_response()["id"])
      post :create, @plitem2
      pli2 = Plitem.find(get_response()["id"])

      set_session("b")
      get :index, :playlist_id => @pl.uuid
      post :remove, :playlist_id => @pl.uuid, :id => pli1.id
      get :index, :playlist_id => @pl.uuid
      json = get_response
      json[0]["id"].should eq pli2.id
      json.length.should eq 1

      set_session("a")
      get :index, :playlist_id => @pl.uuid
      json = get_response
      json[0]["id"].should eq pli1.id
      json[1]["id"].should eq pli2.id
      json.length.should eq 2
    end

    it "will remove item from someone elses gotten playlist" do
      set_session("a")
      post :create, @plitem1
      pli1 = Plitem.find(get_response()["id"])
      post :create, @plitem2
      pli2 = Plitem.find(get_response()["id"])

      post :remove, :playlist_id => @pl.uuid, :id => pli1.id

      set_session("b")
      get :index, :playlist_id => @pl.uuid
      json = get_response
      json[0]["id"].should eq pli2.id
      json.length.should eq 1
    end

    it "if #{Plitem::REMOVAL_RATE} of people remove item it is removed" do
      set_session("a")
      post :create, @plitem1
      pli1 = Plitem.find(get_response()["id"])
      post :create, @plitem2
      pli2 = Plitem.find(get_response()["id"])

      set_session("b")
      get :index, :playlist_id => @pl.uuid
      set_session("c")
      get :index, :playlist_id => @pl.uuid
      set_session("d")
      get :index, :playlist_id => @pl.uuid
      post :remove, :playlist_id => @pl.uuid, :id => pli1.id

      set_session("e")
      get :index, :playlist_id => @pl.uuid
      json = get_response
      json[0]["id"].should eq pli2.id
      json.length.should eq 1
    end

    it "if less than #{Plitem::REMOVAL_RATE} of people remove item it is NOT removed" do
      set_session("a")
      post :create, @plitem1
      pli1 = Plitem.find(get_response()["id"])
      post :create, @plitem2
      pli2 = Plitem.find(get_response()["id"])

      set_session("b")
      get :index, :playlist_id => @pl.uuid
      set_session("c")
      get :index, :playlist_id => @pl.uuid
      set_session("d")
      get :index, :playlist_id => @pl.uuid
      set_session("e")
      get :index, :playlist_id => @pl.uuid

      post :remove, :playlist_id => @pl.uuid, :id => pli1.id

      set_session("f")
      get :index, :playlist_id => @pl.uuid
      json = get_response
      json[0]["id"].should eq pli1.id
      json[1]["id"].should eq pli2.id
      json.length.should eq 2
    end

  end

end
