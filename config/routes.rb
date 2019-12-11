Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "rocks#index"
  resources :rocks do
    resources :comments, only: :create
  end
end
