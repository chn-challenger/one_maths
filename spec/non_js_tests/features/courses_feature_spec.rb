  feature 'courses' do
  let!(:super_admin){create_super_admin}
  let!(:admin)  { create_admin   }
  let!(:student){ create_student }
  let!(:course){ create_course }

  context 'adding a course' do
    scenario 'a course admin can add a course'do
      sign_in admin
      visit courses_path
      click_link 'Add a course'
      fill_in 'Name', with: 'A-Level Maths'
      fill_in 'Description', with: '2 year course'
      click_button 'Create Course'
      expect(page).to have_content 'A-Level Maths'
      expect(page).to have_content '2 year course'
      expect(current_path).to eq "/courses"
    end

    scenario 'cannot add a course if not signed in' do
      visit courses_path
      expect(page).not_to have_link 'Add a course'
    end

    scenario 'cannot visit the add course page unless signed in' do
      visit '/courses/new'
      expect(current_path).to eq "/courses"
      expect(page).to have_content 'Only admins can access this page'
    end

    scenario 'cannot add a course if signed in as a student' do
      sign_in student
      visit courses_path
      expect(page).not_to have_link 'Add a course'
    end

    scenario 'cannot visit the add course page if signed in as a student' do
      sign_in student
      visit '/courses/new'
      expect(current_path).to eq "/courses"
      expect(page).to have_content 'Only admins can access this page'
    end
  end

  context 'updating courses' do
    scenario 'an admin can edit a course' do
      sign_in admin
      visit '/courses'
      click_link 'Edit'
      fill_in 'Name', with: 'A-Level Maths'
      fill_in 'Description', with: '2 year course'
      click_button 'Update Course'
      expect(page).to have_content 'A-Level Maths'
      expect(page).to have_content '2 year course'
      expect(current_path).to eq "/courses"
    end

    scenario 'when not signed in cannot see edit link' do
      visit '/courses'
      expect(page).not_to have_link 'Edit'
    end

    scenario 'when not signed in cannot visit edit page to edit a course' do
      visit "/courses/#{course.id}/edit"
      expect(page).to have_content 'You can only edit your own course'
      expect(current_path).to eq '/courses'
    end

    scenario 'a student cannot see edit link' do
      sign_in student
      visit '/courses'
      expect(page).to have_link 'Edit', count: 1
    end

    scenario 'a student cannot visit edit page to edit a course' do
      sign_in student
      visit "/courses/#{course.id}/edit"
      expect(page).to have_content 'You can only edit your own course'
      expect(current_path).to eq '/courses'
    end
  end

  context 'deleting courses' do
    scenario 'a super admin can delete a course' do
      sign_in super_admin
      visit '/courses'
      click_link 'Delete'
      expect(page).not_to have_content course.name
      expect(page).not_to have_content course.description
      expect(page).to have_content 'Course deleted successfully'
      expect(current_path).to eq "/courses"
    end

    scenario 'an admin do not see delete a course link' do
      sign_in admin
      visit '/courses'
      expect(page).not_to have_link 'Delete'
    end

    scenario 'an admin can send delete request to delete a course' do
      sign_in admin
      page.driver.submit :delete, "/courses/#{course.id}",{}
      expect(page).to have_content 'Course deleted successfully'
      expect(current_path).to eq '/courses'
    end

    scenario 'when not signed in cannot see delete link' do
      visit '/courses'
      expect(page).not_to have_link 'Delete'
    end

    scenario 'when not signed in cannot send delete request' do
      page.driver.submit :delete, "/courses/#{course.id}",{}
      expect(page).to have_content 'Only admin can delete courses'
      expect(current_path).to eq '/courses'
    end

    scenario 'a student cannot see delete link' do
      sign_in student
      visit '/courses'
      expect(page).not_to have_link 'Delete'
    end

    scenario 'a student cannot send a delete request' do
      sign_in student
      page.driver.submit :delete, "/courses/#{course.id}",{}
      expect(page).to have_content 'Only admin can delete courses'
      expect(current_path).to eq '/courses'
    end
  end
end
