require 'rails_helper'

def sign_up_tester
  visit('/')
  click_link('Sign up')
  fill_in('Email', with: 'tester@example.com')
  fill_in('Password', with: 'testtest')
  fill_in('Password confirmation', with: 'testtest')
  click_button('Sign up')
  visit "/courses"
end

def sign_in_maker
  visit '/'
  click_link 'Sign in'
  fill_in 'Email', with: 'maker@maker.com'
  fill_in 'Password', with: '12344321'
  click_button 'Log in'
  visit '/'
end

def create_maker
  maker = Maker.create(email: 'maker@maker.com', password: '12344321',
    password_confirmation: '12344321')
end

def create_course(maker)
  maker.courses.create(name:'Science',description:'Super fun!')
end

def create_unit(course,maker)
  course.units.create_with_maker({name:'Core 1', description:'Basic maths'},maker)
end

def create_topic(unit,maker)
  unit.topics.create_with_maker({name:'Indices', description:'blank for now'},maker)
end

def create_lesson(topic,maker)
  topic.lessons.create_with_maker({name:'Index multiplication',
    description:'times divide power again of indices',video:"0QjF6A3Zwkk"},
    maker)
end

def create_question(lesson,maker)
  lesson.questions.create_with_maker({question_text:'Solve $2+x=5$',
    solution:'$x = 3$'},maker)
end

feature 'questions' do
  context 'A lesson with no questions' do
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:unit){create_unit(course,maker)}
    let!(:topic){create_topic(unit,maker)}
    let!(:lesson){create_lesson(topic,maker)}

    scenario 'should display a prompt to add a question' do
      sign_in_maker
      expect(current_path).to eq '/'
      expect(page).to have_content 'No questions have been added to Index multiplication'
      expect(page).to have_link 'Add a question to Index multiplication'
    end
  end

  context 'adding questions' do
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:unit){create_unit(course,maker)}
    let!(:topic){create_topic(unit,maker)}
    let!(:lesson){create_lesson(topic,maker)}

    scenario 'when not logged in cannot add a question' do
      visit "/"
      expect(page).not_to have_link "Add a question to Index multiplication"
    end

    scenario 'a maker adding a question to his lesson' do
      sign_in_maker
      click_link 'Add a question to Index multiplication'
      fill_in 'Question text', with: 'Solve $2+x=5$'
      fill_in 'Solution', with: '$x=2$'
      click_button 'Create Question'
      expect(page).to have_content 'Solve $2+x=5$'
      expect(page).to have_content '$x=2$'
      expect(current_path).to eq '/'
    end

    scenario 'a different maker cannot add a question' do
      sign_up_tester
      visit "/lessons/#{lesson.id}/questions/new"
      expect(page).not_to have_link "Add a question to Index multiplication"
      expect(page).to have_content 'You can only add questions to your own lessons'
      expect(current_path).to eq '/'
    end
  end


end
