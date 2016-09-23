Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: 'users/registrations' }

  root "courses#index"

  controller :pages do
    get :home
    get :about
    get :contact
    get :faq
    get :blog
    get :test_file
  end

  controller :answered_questions do
    get :answered_questions
    post :get_student
  end


  resources :courses, shallow: true do
    resources :units do
      resources :topics do
        get :next_question, on: :member
        get :new_question, on: :member
        post :create_question, on: :member
        resources :lessons do
          get :next_question, on: :member
          get :next_question_with_answer, on: :member
          get :new_question, on: :member
          post :create_question, on: :member
          post :remove_question
        end
      end
    end
  end

  resources :questions, shallow: true do
    post :check_with_answer, on: :member
    post :check_answer, on: :member
    post :check_topic_answer, on: :member

    resources :choices

    resources :answers
  end

  match 'questions/select_lesson' => 'questions#select_lesson', :via => :post

end
