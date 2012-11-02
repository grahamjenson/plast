Plast::Application.routes.draw do

  scope "api" do
    resources :playlists , :only => [:show, :create, :update]do
      resources :plitems, :only => [:index, :create]
    end
  end

  root to: "main#index"

end
