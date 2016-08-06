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

def create_maker
  Maker.create(email: 'maker@maker.com', password: '12344321',
    password_confirmation: '12344321')
end

def sign_in_maker
  visit '/'
  click_link 'Sign in'
  fill_in 'Email', with: 'maker@maker.com'
  fill_in 'Password', with: '12344321'
  click_button 'Log in'
  visit '/'
end

feature 'topics' do
  context 'A course unit with no topics' do
    let!(:maker){Maker.create(email: 'maker@maker.com', password: '12344321',
      password_confirmation: '12344321')}
    let!(:science){ maker.courses.create(name:'Science',
      description:'Super fun!')}
    let!(:core_1){ science.units.new(name:'Core 1',
      description:'Basic maths')}
    let!(:core_1_maker){core_1.maker = maker}
    let!(:save_core_1){core_1.save}

    scenario 'should display a prompt to add a topic' do
      sign_in_maker
      expect(current_path).to eq '/'
      expect(page).to have_content 'No topics have been added to Core 1'
      expect(page).to have_link 'Add a topic to Core 1'
    end
  end

end
