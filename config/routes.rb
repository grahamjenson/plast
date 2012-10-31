Plast::Application.routes.draw do

  scope "api" do
    resources :playlists
    resources :plitems
  end

  root to: "main#index"

end
