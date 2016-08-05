require 'rails_helper'

feature 'courses' do
  def sign_up_maker
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    click_button('Sign up')
  end

  context 'no courses have been added' do
    scenario 'should display a prompt to add a course' do
      sign_up_maker
      visit '/courses'
      expect(page).to have_content 'No courses added yet'
      expect(page).to have_link 'Add a course'
    end
  end

  context 'courses have been added' do
    before do
      maker = Maker.create(email: 'maker@maker.com',password: '12344321',
        password_confirmation: '12344321')
      maker.courses.create(name: 'Edxecel A-Level Maths',
        description: 'great course')
    end

    scenario 'display course' do
      visit '/courses'
      expect(page).to have_content('Edxecel A-Level Maths')
      expect(page).not_to have_content('No courses added yet')
    end
  end

  context 'creating courses' do
    let!(:maker){Maker.create(email: 'maker@maker.com', password: '12344321',
      password_confirmation: '12344321')}

    scenario 'no option to create course when not logged on as a maker' do
      visit '/courses'
      expect(page).not_to have_link 'Add a course'
    end

    scenario 'prompts user to fill out a form, then displays the new course' do
      visit '/courses'
      click_link 'Sign in'
      fill_in 'Email', with: 'maker@maker.com'
      fill_in 'Password', with: '12344321'
      click_button 'Log in'
      click_link 'Add a course'
      fill_in 'Name', with: 'A-Level Maths'
      fill_in 'Description', with: '2 year course'
      click_button 'Create Course'
      expect(page).to have_content 'A-Level Maths'
      expect(current_path).to eq '/courses'
    end
  end

  context 'viewing courses' do
    let!(:maker){Maker.create(email: 'maker@maker.com', password: '12344321',
      password_confirmation: '12344321')}
    let!(:science){ maker.courses.create(name:'Science',description:'Super fun!') }

    scenario 'lets a user view a course' do
      visit '/courses'
      click_link 'Science'
      expect(page).to have_content 'Super fun!'
      expect(current_path).to eq "/courses/#{science.id}"
    end
  end

  context 'updating courses' do
    let!(:maker){Maker.create(email: 'maker@maker.com', password: '12344321',
      password_confirmation: '12344321')}
    let!(:science){ maker.courses.create(name:'Science',description:'Super fun!') }

    scenario 'lets the creator edit own course' do
      visit '/courses'
      click_link 'Sign in'
      fill_in 'Email', with: 'maker@maker.com'
      fill_in 'Password', with: '12344321'
      click_button 'Log in'
      click_link 'Edit Science'
      fill_in 'Name', with: 'A-Level Maths'
      fill_in 'Description', with: '2 year course'
      click_button 'Update Course'
      expect(page).not_to have_content 'Super fun!'
      expect(page).to have_content 'A-Level Maths'
      expect(page).to have_content '2 year course'
      expect(current_path).to eq "/courses"
    end

    scenario 'non-owning makers cannot see the edit button for a course' do
      sign_up_maker
      expect(page).not_to have_link 'Edit Science'
    end

    scenario 'non-owning makers cannot edit a course' do
      sign_up_maker
      visit "/courses/#{science.id}/edit"
      expect(page).not_to have_link 'Edit Science'
      expect(page).to have_content 'You can only edit your own course'
      expect(current_path).to eq '/courses'
    end
  end

  xcontext 'deleting courses' do
    let!(:science){ Course.create(name:'Science',description:'Super fun!') }

    scenario 'lets a user edit a course' do
      visit '/courses'
      click_link 'Delete Science'
      expect(page).not_to have_content 'Science'
      expect(page).not_to have_content 'Super fun!'
      expect(page).to have_content 'Course deleted successfully'
      expect(current_path).to eq "/courses"
    end
  end
end
