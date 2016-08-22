Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: 'users/registrations' }

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
          get :new_question, on: :member
          post :create_question, on: :member
        end
      end
    end
  end

  resources :questions, shallow: true do
    get :check_answer, on: :member
    resources :choices
  end
end
