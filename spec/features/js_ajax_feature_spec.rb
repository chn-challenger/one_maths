require 'rails_helper'
require 'general_helpers'


feature 'js_lessons', js: true do
# feature 'js_lessons' do
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

  context 'submitting a question' do
    scenario 'once submitted the current question for the lesson is deleted' do
      sign_in admin
      visit "/units/#{ unit.id }"
      click_link 'Add questions to lesson'
      check "question_#{question_1.id}"
      check "question_#{question_2.id}"
      check "question_#{question_3.id}"
      click_button "Update Lesson"
      visit('/')
      click_link 'Sign out'
      sign_in student
      srand(101)
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      expect(page).to have_content "Lesson 1"
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      # puts page.body
      page.choose("choice-#{choice_4.id}")
      click_button 'Submit answer'
      wait_for_ajax
      expect(page).to have_content "Correct answer!"
      expect(page).to have_content "Exp: 100 / 1000 Lvl 1"
      expect(page).to have_content "100/1000 Pass"
      click_link 'Next question'
      wait_for_ajax
      # puts page.body
      page.choose("choice-#{choice_6.id}")
      click_button 'Submit answer'
      expect(page).to have_content "Correct answer!"
      expect(page).to have_content "Exp: 220 / 1000 Lvl 1"
      expect(page).to have_content "220/1000 Pass"
    end

    # scenario 'once submitted the current question for the lesson is deleted' do
    #   sign_in admin
    #   visit "/units/#{ unit.id }"
    #   click_link 'Add questions to lesson'
    #   check "question_#{question_1.id}"
    #   check "question_#{question_2.id}"
    #   check "question_#{question_3.id}"
    #   click_button "Update Lesson"
    #   visit('/')
    #   click_link 'Sign out'
    #   sign_in student
    #   srand(101)
    #   expect(student.has_current_question?(lesson)).to eq false
    #   visit "/units/#{ unit.id }"
    #   expect(student.has_current_question?(lesson)).to eq true
    #   expect(student.fetch_current_question(lesson)).to eq question_2
    #   click_link 'Sign out'
    #   sign_in student
    #   srand(200)
    #   visit "/units/#{ unit.id }"
    #   expect(student.has_current_question?(lesson)).to eq true
    #   expect(student.fetch_current_question(lesson)).to eq question_2
    #   expect(AnsweredQuestion.all.length).to eq 0
    #   page.choose("choice-#{choice_4.id}")
    #   click_button 'Submit answer'
    #   expect(AnsweredQuestion.all.length).to eq 1
    #   expect(student.has_current_question?(lesson)).to eq false
    #   srand(203)
    #   visit "/units/#{ unit.id }"
    #   expect(student.has_current_question?(lesson)).to eq true
    #   expect(student.fetch_current_question(lesson)).to eq question_1
    #   page.choose("choice-#{choice_2.id}")
    #   click_button 'Submit answer'
    #   expect(AnsweredQuestion.all.length).to eq 2
    # end
    #
    # scenario 'answered questions no longer appear again eg 1' do
    #   sign_in admin
    #   visit "/units/#{ unit.id }"
    #   click_link 'Add questions to lesson'
    #   check "question_#{question_1.id}"
    #   check "question_#{question_2.id}"
    #   check "question_#{question_3.id}"
    #   click_button "Update Lesson"
    #   visit('/')
    #   click_link 'Sign out'
    #   sign_in student
    #   srand(103)
    #   visit "/units/#{ unit.id }"
    #   expect(page).to have_content "question text 2"
    #   page.choose("choice-#{choice_4.id}")
    #   click_button 'Submit answer'
    #   visit "/units/#{ unit.id }"
    #   expect(page).not_to have_content "question text 2"
    #   expect(page).to have_content "question text 3"
    # end
    #
    # scenario 'answered questions no longer appear again eg 2' do
    #   sign_in admin
    #   visit "/units/#{ unit.id }"
    #   click_link 'Add questions to lesson'
    #   check "question_#{question_1.id}"
    #   check "question_#{question_2.id}"
    #   check "question_#{question_3.id}"
    #   click_button "Update Lesson"
    #   visit('/')
    #   click_link 'Sign out'
    #   sign_in student
    #   srand(101)
    #   visit "/units/#{ unit.id }"
    #   page.choose("choice-#{choice_4.id}")
    #   click_button 'Submit answer'
    #   srand(204)
    #   visit "/units/#{ unit.id }"
    #   expect(page).to have_content "question text 3"
    # end
  end

  # context 'Gaining experience for a lesson' do
  #   scenario 'gaining experience for a lesson for first time' do
  #     lesson.questions = [question_1,question_2,question_3]
  #     lesson.save
  #     sign_in student
  #     srand(100)
  #     visit "/units/#{ unit.id }"
  #     page.choose("choice-#{choice_2.id}")
  #     click_button 'Submit answer'
  #     expect(StudentLessonExp.current_exp(student,lesson)).to eq 100
  #     visit "/units/#{ unit.id }"
  #     expect(page).to have_content '100/1000'
  #   end
  #
  #   scenario 'gaining experience for a lesson again' do
  #     lesson.questions = [question_1,question_2,question_3]
  #     lesson.save
  #     sign_in student
  #     srand(102)
  #     visit "/units/#{ unit.id }"
  #     page.choose("choice-#{choice_2.id}")
  #     click_button 'Submit answer'
  #     visit "/units/#{ unit.id }"
  #     page.choose("choice-#{choice_6.id}")
  #     click_button 'Submit answer'
  #     expect(StudentLessonExp.current_exp(student,lesson)).to eq 200
  #     visit "/units/#{ unit.id }"
  #     expect(page).to have_content '200/1000'
  #   end
  #
  #   scenario 'not gaining experience for a lesson when answering incorrectly' do
  #     lesson.questions = [question_1,question_2,question_3]
  #     lesson.save
  #     sign_in student
  #     srand(102)
  #     visit "/units/#{ unit.id }"
  #     page.choose("choice-#{choice_2.id}")
  #     click_button 'Submit answer'
  #     visit "/units/#{ unit.id }"
  #     page.choose("choice-#{choice_6.id}")
  #     click_button 'Submit answer'
  #     visit "/units/#{ unit.id }"
  #     page.choose("choice-#{choice_3.id}")
  #     click_button 'Submit answer'
  #     expect(StudentLessonExp.current_exp(student,lesson)).to eq 200
  #   end
  #
  #   scenario 'correctly showing maxed out exp' do
  #     student_lesson_exp = create_student_lesson_exp(student,lesson,1500)
  #     expect(StudentLessonExp.current_exp(student,lesson)).to eq 1000
  #   end
  # end
end
