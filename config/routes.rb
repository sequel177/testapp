Rails.application.routes.draw do
  resources :ingredients
  resources :drinks
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope '/api' do
    resources :drinks
  end
end
