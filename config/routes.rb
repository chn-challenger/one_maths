Rails.application.routes.draw do

  devise_for :makers

  root "courses#index"

  controller :pages do
    get :home
    get :about
    get :contact
    get :faq
    get :blog
  end

  resources :courses, shallow: true do
    resources :units do
      resources :topics do
        resources :lessons do
          resources :questions do
            post :check, on: :member
            resources :choices
          end
        end
      end
    end
  end

end
