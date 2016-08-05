Rails.application.routes.draw do
  devise_for :makers
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "courses#index"
  resources :courses
end
