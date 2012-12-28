Plast::Application.routes.draw do

  scope "api" do
    resources :playlists , :only => [:show, :create, :update] do
      member do
        post :remove
        post :add_plitems
        post :branch
      end
    end
    resources :read_only_playlists, :only =>[:show] do
      member do
        post :branch
      end
    end
  end

  match "ytmp3/request" => "main#ytrequestproxy"

  match "/p/:id" => "main#index"
  match "/playlist/:uuid" => "main#index"
  root to: "main#index"

  match "/faq" => "main#faq"
  match "/about" => "main#about"
  match "/feedback" => "main#feedback"
end
