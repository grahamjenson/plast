Plast::Application.routes.draw do

  scope "api" do
    resources :playlists , :only => [:show, :create, :update] do
      resources :plitems, :only => [:show, :index, :create] do
        collection do
          post 'reorder'
        end
        member do
          post 'remove'
        end
      end
    end
    resources :read_only_playlists, :only =>[:show] do
      resources :read_only_plitems, :only => [:index] do
      end
    end
  end

  match "/p/:id" => "main#index"
  match "/playlist/:uuid" => "main#index"
  root to: "main#index"

end
