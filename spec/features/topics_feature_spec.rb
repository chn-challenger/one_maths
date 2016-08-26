require 'rails_helper'
require 'general_helpers'

feature 'topics' do
  let!(:course) { create_course  }
  let!(:unit)   { create_unit course }
  let!(:topic)  { create_topic unit }
  let!(:lesson) { create_lesson topic }
  let!(:admin)  { create_admin   }
  let!(:student){ create_student }
  let!(:question_1){create_question(1)}
  let!(:choice_1){create_choice(question_1,1,false)}
  let!(:choice_2){create_choice(question_1,2,true)}
  let!(:question_2){create_question(2)}
  let!(:choice_3){create_choice(question_2,3,false)}
  let!(:choice_4){create_choice(question_2,4,true)}
  let!(:question_3){create_question(3)}
  let!(:choice_5){create_choice(question_3,5,false)}
  let!(:choice_6){create_choice(question_3,6,true)}

  context 'adding a topic' do
    scenario 'an admin can add a topic' do
      sign_in admin
      visit "/units/#{ unit.id }"
      click_link 'Add a new chapter'
      fill_in 'Name', with: 'Indices'
      fill_in 'Description', with: 'Powers'
      click_button 'Create Topic'
      expect(page).to have_content 'Indices'
      expect(page).to have_content 'Powers'
      expect(current_path).to eq "/units/#{ unit.id }"
    end

    scenario 'cannot add a topic if not signed in' do
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Add a new chapter'
    end

    scenario 'cannot visit the add topic page unless signed in' do
      visit "/units/#{ unit.id }/topics/new"
      expect(current_path).to eq "/units/#{ unit.id }"
      expect(page).to have_content 'You do not have permission to add a topic'
    end

    scenario 'cannot add a topic if signed in as a student' do
      sign_in student
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Add a new chapter'
    end

    scenario 'cannot visit the add topic page if signed in as a student' do
      sign_in student
      visit "/units/#{ unit.id }/topics/new"
      expect(current_path).to eq "/units/#{ unit.id }"
      expect(page).to have_content 'You do not have permission to add a topic'
    end
  end

  context 'updating topics' do
    scenario 'an admin can edit a topic' do
      sign_in admin
      visit "/units/#{ unit.id }"
      click_link 'Edit chapter'
      fill_in 'Name', with: 'New topic'
      fill_in 'Description', with: 'New topic desc'
      click_button 'Update Topic'
      expect(page).to have_content 'New topic'
      expect(page).to have_content 'New topic desc'
      expect(current_path).to eq "/units/#{ unit.id }"
    end

    scenario 'when not signed in cannot see edit link' do
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Edit chapter'
    end

    scenario 'when not signed in cannot visit edit page' do
      visit "/topics/#{ topic.id }/edit"
      expect(page).to have_content 'You do not have permission to edit a topic'
      expect(current_path).to eq "/units/#{ unit.id }"
    end

    scenario 'a student cannot see edit link' do
      sign_in student
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Edit'
    end

    scenario 'a student cannot visit edit page' do
      sign_in student
      visit "/topics/#{ topic.id }/edit"
      expect(page).to have_content 'You do not have permission to edit a topic'
      expect(current_path).to eq "/units/#{ unit.id }"
    end
  end

  context 'deleting topics' do
    scenario 'an admin can delete a topic' do
      sign_in admin
      visit "/units/#{ unit.id }"
      click_link 'Delete chapter'
      expect(page).not_to have_content topic.name
      expect(page).not_to have_content topic.description
      expect(page).to have_content 'Topic deleted successfully'
      expect(current_path).to eq "/units/#{ unit.id }"
    end

    scenario 'an admin can send delete request' do
      sign_in admin
      page.driver.submit :delete, "/topics/#{ topic.id }",{}
      expect(page).to have_content 'Topic deleted successfully'
      expect(current_path).to eq "/units/#{ unit.id }"
    end

    scenario 'when not signed in cannot see delete link' do
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Delete chapter'
    end

    scenario 'when not signed in cannot send delete request' do
      page.driver.submit :delete, "/topics/#{ topic.id }",{}
      expect(page).to have_content 'You do not have permission to delete a topic'
      expect(current_path).to eq "/units/#{ unit.id }"
    end

    scenario 'a student cannot see delete link' do
      sign_in student
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Delete chapter'
    end

    scenario 'a student cannot send a delete request' do
      sign_in student
      page.driver.submit :delete, "/topics/#{ topic.id }",{}
      expect(page).to have_content 'You do not have permission to delete a topic'
      expect(current_path).to eq "/units/#{ unit.id }"
    end
  end

  context 'adding questions to chapters' do
    scenario 'an admin can add a question' do
      sign_in admin
      visit "/units/#{ unit.id }"
      click_link 'Add questions to Chapter'
      check "question_#{question_1.id}"
      check "question_#{question_3.id}"
      click_button 'Update Chapter'
      expect(page).to have_content 'question text 1'
      expect(page).to have_content 'question text 3'
      expect(page).to have_content 'Possible solution 1'
      expect(page).to have_content 'Possible solution 6'
    end
  end
end
