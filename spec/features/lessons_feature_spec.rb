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

feature 'lessons' do
  # context 'A course unit with no topics' do
  #   let!(:maker){create_maker}
  #   let!(:course){create_course(maker)}
  #   let!(:unit){create_unit(course,maker)}
  #   let!(:indices){create_topic(unit,maker)}
  #
  #   scenario 'should display a prompt to add a topic' do
  #     sign_in_maker
  #     expect(current_path).to eq '/'
  #     expect(page).to have_content 'No topics have been added to Core 1'
  #     expect(page).to have_link 'Add a topic to Core 1'
  #   end
  # end

  context 'adding lessons' do
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:unit){create_unit(course,maker)}
    let!(:indices){create_topic(unit,maker)}

    scenario 'when not logged in cannot add a lesson' do
      visit "/"
      expect(page).not_to have_link "Add a lesson to Indices"
    end

    scenario 'a maker adding a lesson to his topic' do
      sign_in_maker
      click_link 'Add a lesson to Indices'
      fill_in 'Name', with: 'Index multiplication'
      fill_in 'Description', with: 'times divide power again of indices'
      fill_in 'Video', with: "0QjF6A3Zwkk"
      click_button 'Create Lesson'
      expect(page).to have_content 'Index multiplication'
      expect(page).to have_content 'times divide power again of indices'
      expect(current_path).to eq '/'
    end

    scenario 'a different maker cannot add a lesson' do
      sign_up_tester
      visit "/topics/#{indices.id}/lessons/new"
      expect(page).not_to have_link "Add a lesson to Indices"
      expect(page).to have_content 'You can only add lessons to your own topics'
      expect(current_path).to eq '/'
    end
  end

end
