Plast::Application.routes.draw do

  scope "api" do
    resources :playlists , :only => [:show, :create, :update] do
      resources :plitems, :only => [:show, :index, :create]
    end
  end

  match "/playlist/:uuid" => "main#index"
  root to: "main#index"

end
