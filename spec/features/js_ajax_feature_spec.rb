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
  let!(:question_4){create_question(4)}
  let!(:choice_7){create_choice(question_4,7,false)}
  let!(:choice_8){create_choice(question_4,8,true)}

  context 'doing questions for a lesson' do
    scenario 'Getting two in a row correct' do
      lesson.questions = [question_1,question_2,question_3]
      lesson.save
      sign_in student
      srand(101)
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
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

    scenario 'Getting one right one wrong and one right' do
      lesson.questions = [question_1,question_2,question_3,question_4]
      lesson.save
      sign_in student
      srand(101)
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      page.choose("choice-#{choice_8.id}")
      click_button 'Submit answer'
      wait_for_ajax
      expect(page).to have_content "Correct answer!"
      expect(page).to have_content "Exp: 100 / 1000 Lvl 1"
      expect(page).to have_content "100/1000 Pass"
      click_link 'Next question'
      wait_for_ajax
      expect(page).to have_content "100 xp + 19 xp streak bonus"
      page.choose("choice-#{choice_3.id}")
      click_button 'Submit answer'
      wait_for_ajax
      expect(page).to have_content "Incorrect"
      expect(page).to have_content "Exp: 100 / 1000 Lvl 1"
      expect(page).to have_content "100/1000 Pass"
      click_link 'Next question'
      wait_for_ajax
      expect(page).to have_content "100 xp + 0 xp streak bonus"
      page.choose("choice-#{choice_2.id}")
      click_button 'Submit answer'
      wait_for_ajax
      expect(page).to have_content "Correct answer!"
      expect(page).to have_content "Exp: 200 / 1000 Lvl 1"
      expect(page).to have_content "200/1000 Pass"
    end

    scenario 'Out of questions' do
      lesson.questions = [question_1]
      lesson.save
      sign_in student
      srand(101)
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      page.choose("choice-#{choice_2.id}")
      click_button 'Submit answer'
      wait_for_ajax
      expect(page).to have_content "Correct answer!"
      expect(page).to have_content "Exp: 100 / 1000 Lvl 1"
      expect(page).to have_content "100/1000 Pass"
      click_link 'Next question'
      wait_for_ajax
      expect(page).to have_content "You have attempted all the questions"
    end
  end

  context 'end of chapter questions' do
    scenario 'Getting two in a row correct' do
      topic.questions = [question_1,question_2,question_3]
      topic.save
      sign_in student
      srand(101)
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      wait_for_ajax
      click_link "Chapter Questions"
      wait_for_ajax
      page.choose("choice-#{choice_4.id}")
      click_button 'Submit answer'
      wait_for_ajax
      expect(page).to have_content "Correct answer!"
      expect(page).to have_content "Exp: 100 / 1000 Lvl 1"
      click_link 'Next question'
      wait_for_ajax
      page.choose("choice-#{choice_6.id}")
      click_button 'Submit answer'
      expect(page).to have_content "Correct answer!"
      expect(page).to have_content "Exp: 220 / 1000 Lvl 1"
    end

    scenario 'Getting one right one wrong and one right' do
      topic.questions = [question_1,question_2,question_3,question_4]
      topic.save
      sign_in student
      srand(101)
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      wait_for_ajax
      click_link "Chapter Questions"
      wait_for_ajax
      page.choose("choice-#{choice_8.id}")
      click_button 'Submit answer'
      wait_for_ajax
      expect(page).to have_content "Correct answer!"
      expect(page).to have_content "Exp: 100 / 1000 Lvl 1"
      click_link 'Next question'
      wait_for_ajax
      expect(page).to have_content "100 xp + 19 xp streak bonus"
      page.choose("choice-#{choice_3.id}")
      click_button 'Submit answer'
      wait_for_ajax
      expect(page).to have_content "Incorrect"
      expect(page).to have_content "Exp: 100 / 1000 Lvl 1"
      click_link 'Next question'
      wait_for_ajax
      expect(page).to have_content "100 xp + 0 xp streak bonus"
      page.choose("choice-#{choice_2.id}")
      click_button 'Submit answer'
      wait_for_ajax
      expect(page).to have_content "Correct answer!"
      expect(page).to have_content "Exp: 200 / 1000 Lvl 1"
    end

    scenario 'Out of questions' do
      topic.questions = [question_1]
      topic.save
      sign_in student
      srand(101)
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      wait_for_ajax
      click_link "Chapter Questions"
      wait_for_ajax
      page.choose("choice-#{choice_2.id}")
      click_button 'Submit answer'
      wait_for_ajax
      expect(page).to have_content "Correct answer!"
      expect(page).to have_content "Exp: 100 / 1000 Lvl 1"
      click_link 'Next question'
      wait_for_ajax
      expect(page).to have_content "You have attempted all the questions"
    end
  end



end
