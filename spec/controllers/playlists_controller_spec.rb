require 'spec_helper'
require_relative './session_helper.rb'
require 'json_helper'


describe PlaylistsController do
  include SessionHelper
  include JSONHelper

  def mockPlItem(i)
    {
      youtubeid: "#{i}",
      title: "#{i}",
      thumbnail: "#{i}",
      length: i,
      }
  end
  before :each do
    @plitem1 = mockPlItem(1)
    @plitem2 = mockPlItem(2)
    @plitem3 = mockPlItem(3)
    @plitem4 = mockPlItem(4)
    @plitem5 = mockPlItem(5)
    @plitem6 = mockPlItem(6)
  end

  describe "GET create" do
    it "will create a playlist with correct uuid" do
      set_session("a")
      post :create
      json = get_response

      json["read_only_id"].should_not eq nil
      pl = Playlist.find(json["read_only_id"])

      json["id"].should_not eq nil
      json["id"].should eq pl.uuid
    end
  end

  describe "GET show" do
    it "will return the playlist with right uuid" do
      pl = Playlist.create()
      uuid = pl.uuid
      set_session("a")
      get :show, id: uuid

      json = get_response
      json["read_only_id"].should_not eq nil
      json["read_only_id"].should eq pl.id

      json["id"].should_not eq nil
      json["id"].should eq uuid
    end

    describe "with plitems" do

      it "will return the plitems for a playlist" do
        session = set_session("a")
        @pl = Playlist.create()
        post :add_plitems, :id => @pl.uuid, :plitems => {0 => @plitem1}
        post :add_plitems, :id => @pl.uuid, :plitems => {0 => @plitem2}

        get :show, :id => @pl.uuid

        json = get_response

        json["plitems"].length.should eq 2
        json["plitems"][0]["title"].should eq @plitem1[:title]
        json["plitems"][1]["title"].should eq @plitem2[:title]
      end

    end
  end

  describe "POST add_plitems" do
    before :each do
      set_session("a")
      post :create
      json = get_response

      @pl = Playlist.find(json["read_only_id"])
    end

    it "will add a single plitem" do
      set_session("a")
      post :add_plitems, :id => @pl.uuid, :plitems => {0 => @plitem1}

      get :show, id: @pl.uuid

      json = get_response
      json[:plitems].length.should eq 1

      json[:plitems][0][:title].should eq @plitem1[:title]
    end

    it "will add multiple items" do
      set_session("a")
      post :add_plitems, :id => @pl.uuid, :plitems => {0 => @plitem1, 1=> @plitem2}

      get :show, id: @pl.uuid

      json = get_response

      json[:plitems].length.should eq 2
      json[:plitems][0][:title].should eq @plitem1[:title]
      json[:plitems][1][:title].should eq @plitem2[:title]
    end

    it "will not add over the limit if added one-at-a-time" do
      set_session("a")
      Plitem::MAX_ITEMS = 5
      post :add_plitems, :id => @pl.uuid, :plitems =>
      {
        0 => @plitem1,
        1 => @plitem2,
        2 => @plitem3,
      }
      post :add_plitems, :id => @pl.uuid, :plitems =>
      {
        0 => @plitem4,
        1 => @plitem5,
        2 => @plitem6
      }
      get :show, id: @pl.uuid
      json = get_response
      json[:plitems].length.should eq 5
    end

    it "will add to the limit all items" do
      set_session("a")
      Plitem::MAX_ITEMS = 5
      post :add_plitems, :id => @pl.uuid, :plitems =>
      {
        0 => @plitem1,
        1=> @plitem2,
        2 => @plitem3,
        3 => @plitem4,
        4 => @plitem5,
        5 => @plitem6
      }

      get :show, id: @pl.uuid
      json = get_response
      json[:plitems].length.should eq 5
    end

    it "will not create plitem with same youtube id" do

    end

    describe "multiple sessions" do

      it "will return the plitems when another session adds" do

      end

    end

  end

  describe "POST remove" do
    before :each do
      set_session("a")
      post :create

      json = get_response
      @pl = Playlist.find(json["read_only_id"])

      post :add_plitems, :id => @pl.uuid, :plitems => {0 => @plitem1, 1=> @plitem2}
    end

    it "will remove a plitem" do
      get :show, id: @pl.uuid
      json = get_response
      json[:plitems][0][:title].should eq @plitem1[:title]

      post :remove, :id => @pl.uuid, :plitem_id => json[:plitems][0][:id]

      get :show, id: @pl.uuid
      json = get_response

      json[:plitems].length.should eq 1
      json[:plitems][0][:title].should eq @plitem2[:title]
    end

    describe "with multiple sessions" do

      it "will not remove item from  someone elses playlist if they have it" do
      end

      it "will remove item from someone elses gotten playlist" do
      end
    end
  end

  describe "POST Update" do

    it "will reorder items for a new sessions" do
    end

    describe "with multiple sessions" do

      it "will not change someone elses order" do
      end

      it "if #{Plitem::REMOVAL_RATE} of people remove item it is removed" do
      end

      it "if less than #{Plitem::REMOVAL_RATE} of people remove item it is NOT removed" do
      end


      it "will average orders of two sessions for a new session" do
      end

    end

  end


end
