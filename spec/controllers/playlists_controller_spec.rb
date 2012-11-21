require 'spec_helper'
require 'session_helper'

describe PlaylistsController do
  include SessionHelper

  describe "GET create" do
    it "will return a playlist with uuid" do
      set_session("a")
      get :create
      set_session("b")
      get :create
      set_session("a")
      get :create
    end
  end


end
