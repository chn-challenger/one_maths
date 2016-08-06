require 'rails_helper'

feature 'courses' do
  def sign_up_tester
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: 'tester@example.com')
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    click_button('Sign up')
  end

  context 'A course with no units' do
    let!(:maker){Maker.create(email: 'maker@maker.com', password: '12344321',
      password_confirmation: '12344321')}
    let!(:science){ maker.courses.create(name:'Science',
      description:'Super fun!')}

    scenario 'should display a prompt to add a unit' do
      visit '/courses'
      click_link 'Sign in'
      fill_in 'Email', with: 'maker@maker.com'
      fill_in 'Password', with: '12344321'
      click_button 'Log in'
      expect(page).to have_content 'No units have been added for Science'
      expect(page).to have_link 'Add a unit for Science'
    end
  end

  context 'units have been added' do
    let!(:maker){Maker.create(email: 'maker@maker.com', password: '12344321',
      password_confirmation: '12344321')}
    let!(:science){ maker.courses.create(name:'Science',
      description:'Super fun!')}
    let!(:core_1){ science.units.new(name:'Core 1',
      description:'Basic maths')}

    scenario 'display course' do
      core_1.maker = maker
      core_1.save
      visit "/courses/#{science.id}/units"
      expect(page).to have_content('Core 1')
      expect(page).to have_content('Basic maths')
    end
  end

  context 'adding units to a course' do
    let!(:maker){Maker.create(email: 'maker@maker.com', password: '12344321',
      password_confirmation: '12344321')}
    let!(:science){ maker.courses.create(name:'Science',
      description:'Super fun!')}

    scenario 'a maker adding a unit to his course' do
      visit '/'
      click_link 'Sign in'
      fill_in 'Email', with: 'maker@maker.com'
      fill_in 'Password', with: '12344321'
      click_button 'Log in'
      visit "/courses/#{science.id}/units"
      click_link 'Add an unit'
      fill_in 'Name', with: 'Core 1'
      fill_in 'Description', with: 'Very simple maths'
      click_button 'Create Unit'
      expect(page).to have_content 'Core 1'
      expect(page).to have_content 'Very simple maths'
    end

    scenario 'a different maker cannot add a unit' do
      sign_up_tester
      visit "/courses/#{science.id}/units/new"
      expect(page).not_to have_link "Add an unit"
      expect(page).to have_content 'You can only add units to your own course'
    end

  end


# <%= f.submit 'Leave Review' %>



end
