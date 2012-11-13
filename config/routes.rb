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
  end

  match "/playlist/:uuid" => "main#index"
  root to: "main#index"

end
