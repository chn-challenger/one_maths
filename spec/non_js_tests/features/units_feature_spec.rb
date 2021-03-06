require 'rails_helper'


feature 'units' do
  let!(:super_admin){create_super_admin}
  let!(:admin)  { create_admin   }
  let!(:student){ create_student }
  let!(:course) { create_course  }
  let!(:unit)   { create_unit course }

  context 'adding a unit' do
    scenario 'a course admin can add a unit' do
      sign_in admin
      visit "/courses/#{ course.id }"
      click_link 'Add a unit'
      fill_in 'Name', with: 'Core 1'
      fill_in 'Description', with: 'First Unit'
      click_button 'Create Unit'
      expect(page).to have_content 'Core 1'
      expect(current_path).to eq "/courses/#{ course.id }"
    end

    scenario 'cannot add a unit if not signed in' do
      visit "/courses/#{ course.id }"
      expect(page).not_to have_link 'Add a unit'
    end

    scenario 'cannot visit the add unit page unless signed in' do
      visit "/courses/#{ course.id }/units/new"
      expect(current_path).to eq new_user_session_path
    end

    scenario 'cannot add a unit if signed in as a student' do
      sign_in student
      visit "/courses/#{ course.id }"
      expect(page).not_to have_link 'Add a unit'
    end

    scenario 'cannot visit the add unit page if signed in as a student' do
      sign_in student
      visit "/courses/#{ course.id }/units/new"
      expect(current_path).to eq "/courses/#{ course.id }"
      expect(page).to have_content 'You do not have permission to add a unit'
    end
  end

  context 'updating units' do
    scenario 'an admin can edit a unit' do
      sign_in admin
      visit "/courses/#{ course.id }"
      click_link 'Edit'
      fill_in 'Name', with: 'New unit'
      fill_in 'Description', with: 'New desc'
      click_button 'Update Unit'
      expect(page).to have_content 'New unit'
      expect(current_path).to eq "/courses/#{ course.id }"
    end

    scenario 'when not signed in cannot see edit link' do
      visit "/courses/#{ course.id }"
      expect(page).not_to have_link 'Edit'
    end

    scenario 'when not signed in cannot visit edit page to edit a unit' do
      visit "/units/#{ unit.id }/edit"
      expect(current_path).to eq new_user_session_path
    end

    scenario 'a student cannot see edit link' do
      sign_in student
      visit "/courses/#{ course.id }"
      expect(page).to have_link 'Edit', count: 1
    end

    scenario 'a student cannot visit edit page to edit a unit' do
      sign_in student
      visit "/units/#{ unit.id }/edit"
      expect(page).to have_content 'You do not have permission to edit a unit'
      expect(current_path).to eq "/courses/#{ course.id }"
    end
  end

  context 'deleting units' do
    scenario 'a super admin can delete a course' do
      sign_in super_admin
      visit "/courses/#{ course.id }"
      click_link 'Delete'
      expect(page).not_to have_content unit.name
      expect(page).not_to have_content unit.description
      expect(page).to have_content 'Unit deleted successfully'
      expect(current_path).to eq "/courses/#{ course.id }"
    end

    scenario 'an admin do not see delete link' do
      sign_in admin
      visit "/courses/#{ course.id }"
      expect(page).not_to have_link 'Delete'
    end

    scenario 'an admin can send delete request to delete a unit' do
      sign_in admin
      page.driver.submit :delete, "/units/#{ unit.id }",{}
      expect(page).to have_content 'Unit deleted successfully'
      expect(current_path).to eq "/courses/#{ course.id }"
    end

    scenario 'when not signed in cannot see delete link' do
      visit "/courses/#{ course.id }"
      expect(page).not_to have_link 'Delete'
    end

    scenario 'when not signed in cannot send delete request' do
      page.driver.submit :delete, "/units/#{ unit.id }",{}
      expect(current_path).to eq new_user_session_path
    end

    scenario 'a student cannot see delete link' do
      sign_in student
      visit "/courses/#{ course.id }"
      expect(page).not_to have_link 'Delete'
    end

    scenario 'a student cannot send a delete request' do
      sign_in student
      page.driver.submit :delete, "/units/#{ unit.id }",{}
      expect(page).to have_content 'You do not have permission to delete a unit'
      expect(current_path).to eq "/courses/#{ course.id }"
    end
  end
end
