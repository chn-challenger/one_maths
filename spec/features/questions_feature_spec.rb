require 'rails_helper'
require 'general_helpers'

feature 'questions' do
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
  let!(:question_4){create_question_with_answer(4)}
  let!(:question_5){create_question_with_answer(5)}
  let!(:question_6){create_question_with_two_answer(6)}
  let!(:question_7){create_question_with_two_answer(7)}

  context 'checking answers to none-multiple choice questions' do
    scenario 'entering correct answer' do
      lesson.questions = [question_4,question_5]
      lesson.save
      sign_in student
      srand(101)
      visit "/units/#{ unit.id }"
      expect(page).to have_content "question text 5"
      fill_in "x5", with: '123,456'
      click_button 'Submit Answers'
      answered_question = AnsweredQuestion.where(user_id:student.id,
        question_id:question_5.id).first
      expect(answered_question.correct).to eq true
    end

    scenario 'entering wrong answer' do
      lesson.questions = [question_4,question_5]
      lesson.save
      sign_in student
      srand(101)
      visit "/units/#{ unit.id }"
      expect(page).to have_content "question text 5"
      fill_in "x5", with: '123,457'
      click_button 'Submit Answers'
      answered_question = AnsweredQuestion.where(user_id:student.id,
        question_id:question_5.id).first
      expect(answered_question.correct).to eq false
    end

    scenario 'entering correct answers for question with two answers' do
      lesson.questions = [question_6,question_7]
      lesson.save
      sign_in student
      srand(101)
      visit "/units/#{ unit.id }"
      # p question_7
      expect(page).to have_content "question text 7"
      fill_in "x7", with: '123,456'
      fill_in "y7", with: '234,567'
      click_button 'Submit Answers'
      answered_question = AnsweredQuestion.where(user_id:student.id,
        question_id:question_7.id).first
      expect(answered_question.correct).to eq true
    end

    scenario 'entering one wrong answer for question with two answers' do
      lesson.questions = [question_6,question_7]
      lesson.save
      sign_in student
      srand(101)
      visit "/units/#{ unit.id }"
      expect(page).to have_content "question text 7"
      fill_in "x7", with: '123,456'
      fill_in "y7", with: 'wrong'
      click_button 'Submit Answers'
      answered_question = AnsweredQuestion.where(user_id:student.id,
        question_id:question_7.id).first
      expect(answered_question.correct).to eq false
    end

  end


  # context 'viewing list of all questions' do
  #   scenario 'when signed in as admin display a list of questions' do
  #     sign_in admin
  #     visit '/'
  #     click_link 'Questions'
  #     expect(page).to have_content "question text 1"
  #     expect(page).to have_content "question text 2"
  #     expect(page).to have_content "solution 1"
  #     expect(page).to have_content "solution 2"
  #   end
  #
  #   scenario 'when not signed, cannot see questions' do
  #     visit '/'
  #     expect(page).not_to have_link "Questions"
  #     visit '/questions'
  #     expect(page).not_to have_content "question text 1"
  #     expect(page).not_to have_content "question text 2"
  #     expect(page).not_to have_content "solution 1"
  #     expect(page).not_to have_content "solution 2"
  #   end
  #
  #   scenario 'when signed in as a student, cannot see questions' do
  #     sign_in student
  #     visit '/'
  #     expect(page).not_to have_link "Questions"
  #     visit '/questions'
  #     expect(page).not_to have_content "question text 1"
  #     expect(page).not_to have_content "question text 2"
  #     expect(page).not_to have_content "solution 1"
  #     expect(page).not_to have_content "solution 2"
  #   end
  # end
  #
  # context 'adding questions' do
  #   scenario 'an admin adding a question from questions page' do
  #     sign_in admin
  #     visit "/questions"
  #     first(:link, 'Add a question').click
  #     fill_in 'Question text', with: 'Solve $2+x=5$'
  #     fill_in 'Solution', with: '$x=2$'
  #     fill_in 'Difficulty level', with: 2
  #     fill_in 'Experience', with: 100
  #     click_button 'Create Question'
  #     expect(page).to have_content 'Solve $2+x=5$'
  #     expect(page).to have_content '$x=2$'
  #     expect(current_path).to eq "/questions/new"
  #   end
  #
  #   scenario 'an admin adding a question from add question page' do
  #     sign_in admin
  #     visit "/"
  #     click_link("Add Question")
  #     fill_in 'Question text', with: 'Solve $2+x=5$'
  #     fill_in 'Solution', with: '$x=2$'
  #     fill_in 'Difficulty level', with: 2
  #     fill_in 'Experience', with: 100
  #     click_button 'Create Question'
  #     expect(page).to have_content 'Solve $2+x=5$'
  #     expect(page).to have_content '$x=2$'
  #     expect(current_path).to eq "/questions/new"
  #   end
  #
  #   scenario 'cannot add a question when not logged in as admin' do
  #     visit '/questions'
  #     expect(page).not_to have_link 'Add a question'
  #     expect(page).to have_content 'Good try but no - you cannot see the questions and solutions list!...:)'
  #     visit '/questions/new'
  #     expect(page).to have_content 'You do not have permission to create a question'
  #   end
  #
  #   scenario 'cannot add a question when logged in as student' do
  #     sign_in student
  #     visit '/questions'
  #     expect(page).not_to have_link 'Add a question'
  #     expect(page).to have_content 'Good try but no - you cannot see the questions and solutions list!...:)'
  #     visit '/questions/new'
  #     expect(page).to have_content 'You do not have permission to create a question'
  #   end
  # end
  #
  # context 'updating questions' do
  #   scenario 'an admin can update questions' do
  #     sign_in admin
  #     visit "/questions"
  #     click_link("edit-question-#{question_1.id}")
  #     fill_in 'Question text', with: 'New question'
  #     fill_in 'Solution', with: 'New solution'
  #     click_button 'Update Question'
  #     expect(page).to have_content 'New question'
  #     expect(page).to have_content 'New solution'
  #     expect(page).to have_content "question text 2"
  #     expect(page).to have_content "solution 2"
  #     expect(current_path).to eq "/questions/new"
  #   end
  #
  #   scenario "when not signed in cannot edit questions" do
  #     visit "/questions"
  #     expect(page).not_to have_link "Edit question"
  #     visit "/questions/#{question_1.id}/edit"
  #     expect(page).to have_content 'You do not have permission to edit a question'
  #     expect(current_path).to eq "/questions"
  #   end
  #
  #   scenario "a student cannot edit questions" do
  #     sign_in student
  #     visit "/questions"
  #     expect(page).not_to have_link "Edit question"
  #     visit "/questions/#{question_1.id}/edit"
  #     expect(page).to have_content 'You do not have permission to edit a question'
  #     expect(current_path).to eq "/questions"
  #   end
  # end
  #
  # context 'deleting questions' do
  #   scenario 'an admin can delete their own questions' do
  #     sign_in admin
  #     visit "/questions"
  #     click_link("delete-question-#{question_1.id}")
  #     expect(page).not_to have_content 'question text 1'
  #     expect(page).not_to have_content 'solution 1'
  #     expect(current_path).to eq "/questions"
  #   end
  #
  #   scenario "when not signed in cannot delete questions" do
  #     visit "/questions"
  #     expect(page).not_to have_css "#delete-question-#{question_1.id}"
  #     page.driver.submit :delete, "/questions/#{question_1.id}",{}
  #     expect(page).to have_content 'You do not have permission to delete a question'
  #   end
  #
  #   scenario "a student cannot delete another maker's questions" do
  #     sign_in student
  #     visit "/questions"
  #     expect(page).not_to have_css "#delete-question-#{question_1.id}"
  #     page.driver.submit :delete, "/questions/#{question_1.id}",{}
  #     expect(page).to have_content 'You do not have permission to delete a question'
  #   end
  # end
end
