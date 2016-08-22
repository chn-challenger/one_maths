require 'rails_helper'
require 'general_helpers'

feature 'choices' do
  let!(:admin)  { create_admin   }
  let!(:student){ create_student }
  let!(:question_1){create_question(1)}
  let!(:choice_1){create_choice(question_1,1,false)}
  let!(:choice_2){create_choice(question_1,2,true)}

  context 'Displaying choices' do
    scenario 'should display choices when signed in as admin' do
      sign_in admin
      visit "/questions"
      expect(current_path).to eq "/questions"
      expect(page).to have_content 'Possible solution 1'
    end

    scenario 'should not display choices when not signed in' do
      visit "/questions"
      expect(current_path).to eq "/questions"
      expect(page).not_to have_content 'Possible solution 1'
    end

    scenario 'should not display choices when signed in as a student' do
      sign_in student
      visit "/questions"
      expect(current_path).to eq "/questions"
      expect(page).not_to have_content 'Possible solution 1'
    end
  end

  context 'adding choices' do
    scenario 'an admin can add a choice to a question' do
      sign_in admin
      visit "/questions"
      click_link 'Add a choice to question'
      fill_in 'Content', with: 'Possible solution 5'
      select 'Mark as the right choice', from: 'choice_correct'
      click_button 'Create Choice'
      expect(page).to have_content 'Possible solution 5'
      expect(current_path).to eq "/questions"
    end

    scenario 'when not logged on cannot add a choice' do
      visit "/questions"
      expect(page).not_to have_link 'Add a choice to question'
      visit "/questions/#{question_1.id}/choices/new"
      expect(page).to have_content 'You do not have permission to create a choice'
      expect(current_path).to eq "/questions"
    end

    scenario 'a student cannot add a choice' do
      sign_in student
      visit "/questions"
      expect(page).not_to have_link 'Add a choice to question'
      visit "/questions/#{question_1.id}/choices/new"
      expect(page).to have_content 'You do not have permission to create a choice'
      expect(current_path).to eq "/questions"
    end
  end

  context 'updating choices' do
    scenario 'an admin can update choices' do
      sign_in admin
      visit "questions"
      click_link("edit-question-#{question_1.id}-choice-#{choice_1.id}")
      fill_in 'Content', with: 'The correct answer'
      select 'Mark as the right choice', from: 'choice_correct'
      click_button 'Update Choice'
      expect(page).to have_content 'The correct answer'
      expect(current_path).to eq "/questions"
    end

    scenario "when not signed in cannot edit choices" do
      visit "/choices/#{choice_1.id}/edit"
      expect(page).not_to have_link 'Edit choice'
      expect(page).to have_content 'You do not have permission to edit a choice'
      expect(current_path).to eq "/questions"
    end

    scenario "when signed in as a student cannot edit choices" do
      sign_in student
      visit "/choices/#{choice_1.id}/edit"
      expect(page).not_to have_link 'Edit choice'
      expect(page).to have_content 'You do not have permission to edit a choice'
      expect(current_path).to eq "/questions"
    end
  end

  context 'deleting choices' do
    scenario 'an admin can delete choices' do
      sign_in admin
      visit "/questions"
      click_link("delete-question-#{question_1.id}-choice-#{choice_1.id}")
      expect(page).not_to have_content 'Possible solution 1'
      expect(current_path).to eq "/questions"
    end

    scenario "when not signed in cannot delete choices" do
      visit "/questions"
      expect(page).not_to have_link 'Delete choice'
      page.driver.submit :delete, "/choices/#{choice_1.id}",{}
      expect(page).to have_content 'You do not have permission to delete a choice'
    end

    scenario "when signed in as a student cannot delete choices" do
      sign_in student
      visit "/questions"
      expect(page).not_to have_link 'Delete choice'
      page.driver.submit :delete, "/choices/#{choice_1.id}",{}
      expect(page).to have_content 'You do not have permission to delete a choice'
    end
  end
end
