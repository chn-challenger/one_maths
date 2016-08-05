require 'rails_helper'

xfeature 'courses' do
  context 'no courses have been added' do
    scenario 'should display a prompt to add a course' do
      visit '/courses'
      expect(page).to have_content 'No courses added yet'
      expect(page).to have_link 'Add a course'
    end
  end
end
