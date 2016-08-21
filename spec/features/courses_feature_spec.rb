require 'rails_helper'
require 'general_helpers'

feature 'courses' do
  context 'adding a course' do
    let!(:admin)  { create_admin   }
    let!(:student){ create_student }

    scenario 'a course admin can add a course' do
      sign_in admin
      click_link 'Add a course'
      fill_in 'Name', with: 'A-Level Maths'
      fill_in 'Description', with: '2 year course'
      click_button 'Create Course'
      expect(page).to have_content 'A-Level Maths'
      expect(page).to have_content '2 year course'
      expect(current_path).to eq "/courses"
    end

    scenario 'cannot add a course if not signed in' do
      visit '/'
      expect(page).not_to have_link 'Add a course'
    end

    scenario 'cannot visit the add course page unless signed in' do
      visit '/courses/new'
      expect(current_path).to eq "/courses"
      expect(page).to have_content 'Only admins can access this page'
    end

    scenario 'cannot add a course if signed in as a student' do
      sign_in student
      visit '/'
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
    let!(:admin)  { create_admin   }
    let!(:student){ create_student }
    let!(:course){ create_course }

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
      expect(page).not_to have_link 'Edit'
    end

    scenario 'a student cannot visit edit page to edit a course' do
      sign_in student
      visit "/courses/#{course.id}/edit"
      expect(page).to have_content 'You can only edit your own course'
      expect(current_path).to eq '/courses'
    end
  end

  # context 'updating courses' do
  #   let!(:maker){Maker.create(email: 'maker@maker.com', password: '12344321',
  #     password_confirmation: '12344321', role: 'admin')}
  #   let!(:science){ Course.create(name:'Science',description:'Super fun!') }
  #
  #   scenario 'lets the creator edit own course' do
  #     visit '/courses'
  #     click_link 'Sign in'
  #     fill_in 'Email', with: 'maker@maker.com'
  #     fill_in 'Password', with: '12344321'
  #     click_button 'Log in'
  #     click_link 'Edit'
  #     fill_in 'Name', with: 'A-Level Maths'
  #     fill_in 'Description', with: '2 year course'
  #     click_button 'Update Course'
  #     expect(page).not_to have_content 'Super fun!'
  #     expect(page).to have_content 'A-Level Maths'
  #     expect(page).to have_content '2 year course'
  #     expect(current_path).to eq "/courses"
  #   end
  #
  #   scenario 'non-owner makers cannot see the edit button for a course' do
  #     sign_up_tester
  #     expect(page).not_to have_link 'Edit'
  #   end
  #
  #   scenario 'non-owner makers cannot edit a course' do
  #     sign_up_tester
  #     visit "/courses/#{science.id}/edit"
  #     expect(page).to have_content 'You can only edit your own course'
  #     expect(current_path).to eq '/courses'
  #   end
  # end

  # context 'deleting courses' do
  #   let!(:maker){Maker.create(email: 'maker@maker.com', password: '12344321',
  #     password_confirmation: '12344321')}
  #   let!(:science){ maker.courses.create(name:'Science',description:'Super fun!') }
  #
  #   scenario 'lets a user edit a course' do
  #     visit '/courses'
  #     click_link 'Sign in'
  #     fill_in 'Email', with: 'maker@maker.com'
  #     fill_in 'Password', with: '12344321'
  #     click_button 'Log in'
  #     click_link 'Delete'
  #     expect(page).not_to have_content 'Science'
  #     expect(page).not_to have_content 'Super fun!'
  #     expect(page).to have_content 'Course deleted successfully'
  #     expect(current_path).to eq "/courses"
  #   end
  #
  #   scenario 'non-ownder cannot see delete link' do
  #     sign_up_tester
  #     expect(page).not_to have_link 'Delete'
  #   end
  #
  #   scenario 'non-ownder cannot delete the course' do
  #     sign_up_tester
  #     page.driver.submit :delete, "/courses/#{science.id}",{}
  #     expect(page).to have_content 'You can only delete your own course'
  #     expect(current_path).to eq '/courses'
  #   end
  # end
end
