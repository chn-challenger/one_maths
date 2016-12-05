Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: 'users/registrations' }

  scope '/admin', module: 'admin', as: 'admin' do
    resources :users

    controller :users do
      get :edit_user_details
    end
  end

  root "courses#index"

  post '/questions/parser', to: 'questions#parser'

  controller :pages do
    get :home
    get :about
    get :contact
    get :faq
    get :blog
    get :questions_list
    get :download
    post :select_lesson_questions_download
    get :download_lesson_questions
  end

  controller :answered_questions do
    get :answered_questions
    post :get_student
  end

  controller :catalogue do
    get :new_catalogue, to: 'catalogue#new'
    get :exam_questions, to: 'catalogue#exam_questions'
    get '/edit_exam_question/:id', to: 'catalogue#edit'
    delete :delete_tag, to: 'catalogue#delete_tag'
    post :update_tags, to: 'catalogue#update_tags'
    post :image_filter
    post :catalogue, to: 'catalogue#create'
  end

  controller :management do
    get :student_manager
    get :edit_student_questions
    post :get_student_management
    post :edit_experience
    delete :delete_student_questions
    post :toggle_admin_view
  end

  resources :tickets, shallow: true

  resources :jobs do
    put :assign, on: :member
    get :question, on: :member
  end

  resources :comments, shallow: true

  controller :jobs do
    put :reset_exp
    get '/job/archive', to: 'jobs#archive'
    put '/job/approve', to: 'jobs#approve_job'
    get '/job/review', to: 'jobs#review'
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

  resources :tags, shallow: true

  controller :questions do
    post 'questions/select_tags', to: "questions#select_tags"
    post 'questions/select_lesson', to: "questions#select_lesson"
    delete 'questions/delete_tag', to: 'questions#delete_tag'
  end

  resources :questions, shallow: true do
    post :check_with_answer, on: :member
    post :check_answer, on: :member
    post :check_topic_answer, on: :member

    resources :choices do
      get :attach_image, on: :member
      post :create_image, on: :member
    end

    resources :answers
  end

  resources :images, shallow: true

  get '*unmatched_route', to: 'application#raise_not_found'
end
