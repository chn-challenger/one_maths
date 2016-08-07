Rails.application.routes.draw do
  devise_for :makers
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "courses#index"
  resources :courses, shallow: true do
    resources :units do
      resources :topics do
        resources :lessons do
          resources :questions
        end
      end
    end
  end
  #
  # resources :restaurants, shallow: true do
  #   resources :reviews do
  #     resources :endorsements
  #   end
  # end
end
