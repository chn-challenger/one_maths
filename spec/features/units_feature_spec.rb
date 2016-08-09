require 'rails_helper'
require 'general_helpers'

feature 'units' do
  context 'A course with no units' do
    scenario 'should display a prompt to add a unit' do
      maker = create_maker
      create_course(maker)
      sign_in_maker
      click_link 'Science'
      expect(page).to have_link 'Add a unit'
    end
  end

  context 'units have been added' do
    scenario 'display course' do
      maker = create_maker
      course = create_course(maker)
      create_unit(course,maker)
      visit "/courses/#{course.id}"
      expect(page).to have_content('Core 1')
      expect(page).to have_content('Basic maths')
    end
  end

  context 'adding units to a course' do
    let!(:maker){create_maker}
    let!(:science){create_course(maker)}

    scenario 'when not logged in cannot add unit' do
      visit "/courses/#{science.id}"
      expect(page).not_to have_link "Add a unit"
    end

    scenario 'a maker adding a unit to his course' do
      sign_in_maker
      visit "/courses/#{science.id}"
      click_link 'Add a unit'
      fill_in 'Name', with: 'Core 1'
      fill_in 'Description', with: 'Very simple maths'
      click_button 'Create Unit'
      expect(page).to have_content 'Core 1'
      expect(page).to have_content 'Very simple maths'
      expect(current_path).to eq "/courses/#{science.id}"
    end

    scenario 'a different maker cannot add a unit' do
      sign_up_tester
      visit "/courses/#{science.id}/units/new"
      expect(page).not_to have_link "Add a unit"
      expect(page).to have_content 'You can only add units to your own course'
      expect(current_path).to eq '/'
    end
  end

  context 'viewing units in a course' do
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:core_1){create_unit(course,maker)}

    scenario 'public can view units in a course' do
      visit "/courses/#{course.id}"
      click_link 'Basic maths'
      expect(page).to have_content 'Core 1'
      expect(current_path).to eq "/units/#{core_1.id}"
    end
  end

  context 'updating units in a course' do
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:core_1){create_unit(course,maker)}

    scenario 'a maker can update his own units' do
      sign_in_maker
      visit "/courses/#{course.id}"
      click_link 'Edit'
      fill_in 'Name', with: 'Mechanics 1'
      fill_in 'Description', with: 'Basic physics'
      click_button 'Update Unit'
      expect(page).to have_content 'Mechanics 1'
      expect(current_path).to eq "/courses/#{course.id}"
    end

    scenario "a maker cannot edit someone else's units" do
      sign_up_tester
      visit "/courses/#{course.id}"
      expect(page).not_to have_link 'Edit'
      visit "/units/#{core_1.id}/edit"
      expect(page).to have_content 'You can only edit your own units'
      expect(current_path).to eq "/courses/#{course.id}"
    end
  end

  context 'deleting units' do
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:core_1){create_unit(course,maker)}

    scenario 'a maker can delete their own unit' do
      sign_in_maker
      visit "/courses/#{course.id}"
      click_link 'Delete'
      expect(page).not_to have_content "Core 1"
      expect(current_path).to eq "/courses/#{course.id}"
    end

    scenario "a maker cannot delete another maker's units" do
      sign_up_tester
      visit "/courses/#{course.id}"
      expect(page).not_to have_link 'Delete'
      page.driver.submit :delete, "/units/#{core_1.id}",{}
      expect(page).to have_content 'Can only delete your own units'
    end
  end
end



# <%= f.submit 'Leave Review' %>
