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
end
