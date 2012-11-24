Plast::Application.routes.draw do

  scope "api" do
    resources :playlists , :only => [:show, :create, :update] do
      member do
        post :remove
        post :add_plitems
      end
    end
    resources :read_only_playlists, :only =>[:show] do
    end
  end

  match "/p/:id" => "main#index"
  match "/playlist/:uuid" => "main#index"
  root to: "main#index"

end
