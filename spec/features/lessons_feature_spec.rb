require 'rails_helper'
require 'general_helpers'

feature 'lessons' do
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

  context 'adding a lesson' do
    scenario 'an admin can add a lessons' do
      sign_in admin
      visit "/units/#{ unit.id }"
      click_link 'Add a lesson to chapter'
      fill_in 'Name', with: 'New lesson'
      fill_in 'Description', with: 'Lesson desc'
      click_button 'Create Lesson'
      expect(page).to have_content 'New lesson'
      expect(current_path).to eq "/units/#{ unit.id }"
    end

    scenario 'cannot add a lesson if not signed in' do
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Add a lesson to chapter'
    end

    scenario 'cannot visit the add lesson page unless signed in' do
      visit "/topics/#{ topic.id }/lessons/new"
      expect(current_path).to eq "/units/#{ unit.id }"
      expect(page).to have_content 'You do not have permission to add a lesson'
    end

    scenario 'cannot add a lesson if signed in as a student' do
      sign_in student
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Add a lesson to chapter'
    end

    scenario 'cannot visit the add lesson page if signed in as a student' do
      sign_in student
      visit "/topics/#{ topic.id }/lessons/new"
      expect(current_path).to eq "/units/#{ unit.id }"
      expect(page).to have_content 'You do not have permission to add a lesson'
    end
  end
  #
  context 'updating lessons' do
    scenario 'an admin can edit a lesson' do
      sign_in admin
      visit "/units/#{ unit.id }"
      click_link 'Edit lesson'
      fill_in 'Name', with: 'New lesson one'
      fill_in 'Description', with: 'New lesson desc'
      click_button 'Update Lesson'
      expect(page).to have_content 'New lesson one'
      expect(current_path).to eq "/units/#{ unit.id }"
    end

    scenario 'when not signed in cannot see edit link' do
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Edit lesson'
    end

    scenario 'when not signed in cannot visit edit page' do
      visit "/lessons/#{ lesson.id }/edit"
      expect(page).to have_content 'You do not have permission to edit a lesson'
      expect(current_path).to eq "/units/#{ unit.id }"
    end

    scenario 'a student cannot see edit link' do
      sign_in student
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Edit lesson'
    end

    scenario 'a student cannot visit edit page' do
      sign_in student
      visit "/lessons/#{ lesson.id }/edit"
      expect(page).to have_content 'You do not have permission to edit a lesson'
      expect(current_path).to eq "/units/#{ unit.id }"
    end
  end

  context 'deleting lessons' do
    scenario 'an admin can delete a lesson' do
      sign_in admin
      visit "/units/#{ unit.id }"
      click_link 'Delete lesson'
      expect(page).not_to have_content lesson.name
      expect(page).to have_content 'Lesson deleted successfully'
      expect(current_path).to eq "/units/#{ unit.id }"
    end

    scenario 'an admin can send delete request' do
      sign_in admin
      page.driver.submit :delete, "/lessons/#{ lesson.id }",{}
      expect(page).to have_content 'Lesson deleted successfully'
      expect(current_path).to eq "/units/#{ unit.id }"
    end

    scenario 'when not signed in cannot see delete link' do
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Delete lesson'
    end

    scenario 'when not signed in cannot send delete request' do
      page.driver.submit :delete, "/lessons/#{ lesson.id }",{}
      expect(page).to have_content 'You do not have permission to delete a lesson'
      expect(current_path).to eq "/units/#{ unit.id }"
    end

    scenario 'a student cannot see delete link' do
      sign_in student
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Delete lesson'
    end

    scenario 'a student cannot send a delete request' do
      sign_in student
      page.driver.submit :delete, "/lessons/#{ lesson.id }",{}
      expect(page).to have_content 'You do not have permission to delete a lesson'
      expect(current_path).to eq "/units/#{ unit.id }"
    end
  end

  context 'adding questions to lesson' do
    scenario 'an admin can add questions to a lesson' do
      sign_in admin
      visit "/units/#{ unit.id }"
      click_link 'Add questions to lesson'
      check "question_#{question_1.id}"
      check "question_#{question_3.id}"
      click_button "Update Lesson"
      expect(page).to have_content 'question text 1'
      expect(page).to have_content 'solution 1'
      expect(page).to have_content 'Possible solution 1'
      expect(page).to have_content 'Possible solution 2'
      expect(page).to have_content 'question text 3'
      expect(page).to have_content 'solution 3'
      expect(page).to have_content 'Possible solution 5'
      expect(page).to have_content 'Possible solution 6'
      expect(page).not_to have_content 'Possible solution 3'
    end

    scenario 'an admin can change the list of questions on a lesson' do
      sign_in admin
      visit "/units/#{ unit.id }"
      click_link 'Add questions to lesson'
      check "question_#{question_1.id}"
      check "question_#{question_3.id}"
      click_button "Update Lesson"
      click_link 'Add questions to lesson'
      uncheck "question_#{question_1.id}"
      uncheck "question_#{question_3.id}"
      check "question_#{question_2.id}"
      click_button "Update Lesson"
      expect(page).to have_content 'question text 2'
      expect(page).to have_content 'solution 2'
      expect(page).to have_content 'Possible solution 3'
      expect(page).to have_content 'Possible solution 4'
      expect(page).not_to have_content 'question text 1'
      expect(page).not_to have_content 'question text 3'
      expect(page).not_to have_content 'Possible solution 1'
      expect(page).not_to have_content 'Possible solution 6'
    end

    scenario 'when not logged on cannot add questions to a lesson' do
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Add questions to lesson'
      visit "/lessons/#{lesson.id}/new_question"
      expect(page).to have_content 'You do not have permission to add questions to lesson'
      expect(current_path).to eq "/units/#{ unit.id }"
    end

    scenario 'when not logged on as a student cannot add questions to a lesson' do
      sign_in student      
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Add questions to lesson'
      visit "/lessons/#{lesson.id}/new_question"
      expect(page).to have_content 'You do not have permission to add questions to lesson'
      expect(current_path).to eq "/units/#{ unit.id }"
    end
  end
end
