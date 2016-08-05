require 'rails_helper'

feature 'courses' do
  context 'no courses have been added' do
    scenario 'should display a prompt to add a course' do
      visit '/courses'
      expect(page).to have_content 'No courses added yet'
      expect(page).to have_link 'Add a course'
    end
  end

  context 'restaurants have been added' do
    before do
      Course.create(name: 'Edxecel A-Level Maths')
    end

    scenario 'display course' do
      visit '/courses'
      expect(page).to have_content('Edxecel A-Level Maths')
      expect(page).not_to have_content('No courses added yet')
    end
  end

  context 'creating courses' do
    scenario 'prompts user to fill out a form, then displays the new course' do
      visit '/courses'
      click_link 'Add a course'
      fill_in 'Name', with: 'A-Level Maths'
      fill_in 'Description', with: '2 year course'
      click_button 'Create Course'
      expect(page).to have_content 'A-Level Maths'
      expect(current_path).to eq '/courses'
    end
  end

  context 'viewing courses' do
    let!(:science){ Course.create(name:'Science',description:'Super fun!') }

    scenario 'lets a user view a course' do
      visit '/courses'
      click_link 'Science'
      expect(page).to have_content 'Super fun!'
      expect(current_path).to eq "/courses/#{science.id}"
    end
  end

  context 'updating courses' do
    let!(:science){ Course.create(name:'Science',description:'Super fun!') }

    scenario 'lets a user edit a course' do
      visit '/courses'
      click_link 'Edit Science'
      fill_in 'Name', with: 'A-Level Maths'
      fill_in 'Description', with: '2 year course'
      click_button 'Update Course'
      expect(page).not_to have_content 'Super fun!'
      expect(page).to have_content 'A-Level Maths'
      expect(page).to have_content '2 year course'
      expect(current_path).to eq "/courses"
    end
  end
end
