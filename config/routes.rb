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
      # post :check_answer, on: :member   #new new new
      resources :topics do
        resources :lessons do
          get :new_question, on: :member
          post :create_question, on: :member
        end
      end
    end
  end

  resources :questions, shallow: true do
    post :check_answer, on: :member   #new new new
    # get :check_answer, on: :member  #js working
    resources :choices
  end
end
