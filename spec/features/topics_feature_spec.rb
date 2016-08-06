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

feature 'topics' do
  context 'A course unit with no topics' do
    # let!(:maker){Maker.create(email: 'maker@maker.com', password: '12344321',
    #   password_confirmation: '12344321')}
    # let!(:science){ maker.courses.create(name:'Science',
    #   description:'Super fun!')}
    # let!(:core_1){ science.units.new(name:'Core 1',
    #   description:'Basic maths')}
    # let!(:core_1_maker){core_1.maker = maker}
    # let!(:save_core_1){core_1.save}
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:core_1){create_unit(course,maker)}

    scenario 'should display a prompt to add a topic' do
      sign_in_maker
      expect(current_path).to eq '/'
      expect(page).to have_content 'No topics have been added to Core 1'
      expect(page).to have_link 'Add a topic to Core 1'
    end
  end

  # context 'topics have been added' do
  #   let!(:maker){create_maker}
  #   let!(:course){create_course(maker)}
  #   let!(:unit){create_unit(course,maker)}
  #   let!(:indices){unit.topics.new(name: 'Indices', description: 'blank default')}
  #
  #   scenario 'display the added topics' do
  #     indices.maker = maker
  #     indices.save
  #     visit '/'
  #     expect(page).to have_content 'Indices'
  #   end
  # end

  context 'adding topics' do
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:unit){create_unit(course,maker)}

    scenario 'a maker adding a unit to his course' do
      sign_in_maker
      click_link 'Add a topic to Core 1'
      fill_in 'Name', with: 'Indices'
      fill_in 'Description', with: 'blank'
      click_button 'Create Topic'
      expect(page).to have_content 'Indices'
      expect(page).to have_content 'blank'
      expect(current_path).to eq '/'
    end

  end

end
