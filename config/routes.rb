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
        get :next_question, on: :member
        get :new_question, on: :member
        post :create_question, on: :member
        resources :lessons do
          get :next_question, on: :member
          get :new_question, on: :member
          post :create_question, on: :member
          post :remove_question
        end
      end
    end
  end

  resources :questions, shallow: true do
    post :check_answer, on: :member
    post :check_topic_answer, on: :member
    resources :choices
  end
end
