feature 'js_topics', js: true do
  let!(:course) { create_course  }
  let!(:unit)   { create_unit course }
  let!(:topic)  { create_topic unit }
  let!(:lesson) { create_lesson topic, 1, 'Published' }
  let!(:admin)  { create_admin   }
  let!(:student){ create_student }
  let!(:student_2){ create_student_2 }
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
  let!(:question_5){create_question(5)}
  let!(:answer_1){create_answer(question_5,1)}
  let!(:answer_2){create_answer(question_5,2)}
  let!(:question_6){create_question(6)}
  let!(:answer_3){create_answer(question_6,3)}
  let!(:answer_4){create_answer(question_6,4)}
  let!(:question_7){create_question(7)}
  let!(:answer_5){create_answer(question_7,5)}
  let!(:answer_6){create_answer(question_7,6)}

  let!(:question_25){create_question_with_order(25,"b1")}
  let!(:answer_25){create_answers(question_25,[['a=','+5,-8,7.1,6.21']])}
  let!(:question_26){create_question_with_order(26,"b1")}
  let!(:answer_26){create_answers(question_26,[['a=','+5,-8,6.21'],['b=','7'],['c=','4']])}
  let!(:question_27){create_question_with_order(27,"c1")}
  let!(:answer_27){create_answers(question_27,[['a=','+6,-7, 0.2, 3, -1']])}
  let!(:question_28){create_question_with_order(28,"d1")}
  let!(:answer_28){create_answers(question_28,[['a=','+5,-1/8'],['b=','12']])}
  let!(:lesson_exp) { create_student_lesson_exp(student,lesson,1000) }
  let!(:lesson_exp_2) { create_student_lesson_exp(student_2,lesson,550) }

  context 'questions visibility' do
    before(:each) do
      topic.questions = [question_28]
      topic.save
    end

    xscenario 'can\'t see topic questions unless all lessons are complete' do
      sign_in student_2
      visit "/units/#{ unit.id }"
      find("#chapter-collapsable-#{topic.id}").trigger('click')
      find("#chapter-lesson-collapsable-#{topic.id}").trigger('click')
      wait_for_ajax
      expect(page).to have_content 'You need to complete all lessons to see Chapter questions.'
    end

    scenario 'can see topic questions when all lessons are complete' do
      sign_in student
      visit "/units/#{ unit.id }"
      find("#chapter-collapsable-#{topic.id}").trigger('click')
      find("#chapter-lesson-collapsable-#{topic.id}").trigger('click')
      wait_for_ajax
      expect(page).not_to have_content 'You need to complete all lessons to see Chapter questions.'
      expect(page).to have_content question_28.question_text
    end
  end

  context 'Topic multiple choice questions' do
    scenario 'Getting two in a row correct' do
      topic.questions = [question_1,question_2,question_3]
      topic.save
      sign_in student
      srand(101)
      visit "/units/#{ unit.id }"
      find("#chapter-collapsable-#{topic.id}").trigger('click')
      find("#chapter-lesson-collapsable-#{topic.id}").trigger('click')
      wait_for_ajax
      expect(page).to have_content question_2.question_text
      page.choose("choice-#{choice_4.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content "Exp: 100 / #{lesson.pass_experience} Lvl 1"
      click_link 'Next question'
      wait_for_ajax
      expect(page).to have_content question_2.question_text
      if page.has_content?("question text 1")
        page.choose("choice-#{choice_2.id}")
      end
      if page.has_content?("question text 2")
        page.choose("choice-#{choice_4.id}")
      end
      if page.has_content?("question text 3")
        page.choose("choice-#{choice_6.id}")
      end
      click_button 'Submit Answer'
      expect(page).to have_content "Correct!"
      expect(page).to have_content "Exp: 225 / #{lesson.pass_experience} Lvl 1"
    end

    xscenario 'Getting one right one wrong and one right' do
      topic.questions = [question_1,question_2,question_3,question_4]
      topic.save
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      wait_for_ajax
      click_link "Chapter Questions"
      wait_for_ajax
      if page.has_content?("question text 1")
        page.choose("choice-#{choice_2.id}")
      end
      if page.has_content?("question text 2")
        page.choose("choice-#{choice_4.id}")
      end
      if page.has_content?("question text 3")
        page.choose("choice-#{choice_6.id}")
      end
      if page.has_content?("question text 4")
        page.choose("choice-#{choice_8.id}")
      end
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content "Exp: 100 / #{lesson.pass_experience} Lvl 1"
      click_link 'Next question'
      wait_for_ajax
      expect(page).to have_content "100 xp + 25 xp streak bonus"
      if page.has_content?("question text 1")
        page.choose("choice-#{choice_1.id}")
      end
      if page.has_content?("question text 2")
        page.choose("choice-#{choice_3.id}")
      end
      if page.has_content?("question text 3")
        page.choose("choice-#{choice_5.id}")
      end
      if page.has_content?("question text 4")
        page.choose("choice-#{choice_7.id}")
      end
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Incorrect"
      expect(page).to have_content "Exp: 100 / #{lesson.pass_experience} Lvl 1"
      click_link 'Next question'
      wait_for_ajax
      expect(page).to have_content "100 xp + 0 xp streak bonus"
      if page.has_content?("question text 1")
        page.choose("choice-#{choice_2.id}")
      end
      if page.has_content?("question text 2")
        page.choose("choice-#{choice_4.id}")
      end
      if page.has_content?("question text 3")
        page.choose("choice-#{choice_6.id}")
      end
      if page.has_content?("question text 4")
        page.choose("choice-#{choice_8.id}")
      end
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content "Exp: 200 / #{lesson.pass_experience} Lvl 1"
    end
  end

  #   scenario 'Out of questions' do
  #     topic.questions = [question_1]
  #     topic.save
  #     sign_in student
  #     visit "/units/#{ unit.id }"
  #     click_link "Chapter 1"
  #     wait_for_ajax
  #     click_link "Chapter Questions"
  #     wait_for_ajax
  #     page.choose("choice-#{choice_2.id}")
  #     click_button 'Submit Answer'
  #     wait_for_ajax
  #     expect(page).to have_content "Correct!"
  #     expect(page).to have_content "Exp: 100 / #{lesson.pass_experience} Lvl 1"
  #     click_link 'Next question'
  #     wait_for_ajax
  #     expect(page).to have_content "You have attempted all the questions"
  #   end
  # end
  #
  # context 'Topic answer submission questions' do
  #   scenario 'Getting a Submit Answer question correct' do
  #     topic.questions = [question_5,question_6]
  #     topic.save
  #     sign_in student
  #     srand(101)
  #     visit "/units/#{ unit.id }"
  #     click_link "Chapter 1"
  #     wait_for_ajax
  #     click_link "Chapter Questions"
  #     wait_for_ajax
  #     if page.has_content?("question text 5")
  #       fill_in 'x1', with: '11'
  #       fill_in 'x2', with: '22'
  #     end
  #     if page.has_content?("question text 6")
  #       fill_in 'x3', with: '33'
  #       fill_in 'x4', with: '44'
  #     end
  #     click_button 'Submit Answer'
  #     wait_for_ajax
  #     expect(page).to have_content "Correct!"
  #     expect(page).to have_content "Exp: 100 / #{lesson.pass_experience} Lvl 1"
  #   end
  #
  #   scenario 'Getting two Submit Answer question correct' do
  #     topic.questions = [question_5,question_6]
  #     topic.save
  #     sign_in student
  #     visit "/units/#{ unit.id }"
  #     click_link "Chapter 1"
  #     wait_for_ajax
  #     click_link "Chapter Questions"
  #     wait_for_ajax
  #     if page.has_content?("question text 5")
  #       fill_in 'x1', with: '11'
  #       fill_in 'x2', with: '22'
  #     end
  #     if page.has_content?("question text 6")
  #       fill_in 'x3', with: '33'
  #       fill_in 'x4', with: '44'
  #     end
  #     click_button 'Submit Answer'
  #     wait_for_ajax
  #     expect(page).to have_content "Correct!"
  #     expect(page).to have_content "Exp: 100 / #{lesson.pass_experience} Lvl 1"
  #     click_link 'Next question'
  #     wait_for_ajax
  #     if page.has_content?("question text 5")
  #       fill_in 'x1', with: '11'
  #       fill_in 'x2', with: '22'
  #     end
  #     if page.has_content?("question text 6")
  #       fill_in 'x3', with: '33'
  #       fill_in 'x4', with: '44'
  #     end
  #     click_button 'Submit Answer'
  #     wait_for_ajax
  #     expect(page).to have_content "Correct!"
  #     expect(page).to have_content "Exp: 225 / #{lesson.pass_experience} Lvl 1"
  #   end
  #
  #   scenario 'Submit Answer questions right wrong right' do
  #     topic.questions = [question_5,question_6,question_7]
  #     topic.save
  #     sign_in student
  #     visit "/units/#{ unit.id }"
  #     click_link "Chapter 1"
  #     wait_for_ajax
  #     click_link "Chapter Questions"
  #     wait_for_ajax
  #     if page.has_content?("question text 5")
  #       fill_in 'x1', with: '11'
  #       fill_in 'x2', with: '22'
  #     end
  #     if page.has_content?("question text 6")
  #       fill_in 'x3', with: '33'
  #       fill_in 'x4', with: '44'
  #     end
  #     if page.has_content?("question text 7")
  #       fill_in 'x5', with: '55'
  #       fill_in 'x6', with: '66'
  #     end
  #     click_button 'Submit Answer'
  #     wait_for_ajax
  #     expect(page).to have_content "Correct!"
  #     expect(page).to have_content "Exp: 100 / #{lesson.pass_experience} Lvl 1"
  #     click_link 'Next question'
  #     wait_for_ajax
  #     if page.has_content?("question text 5")
  #       fill_in 'x1', with: 'wrong'
  #       fill_in 'x2', with: 'wrong'
  #     end
  #     if page.has_content?("question text 6")
  #       fill_in 'x3', with: 'wrong'
  #       fill_in 'x4', with: 'wrong'
  #     end
  #     if page.has_content?("question text 7")
  #       fill_in 'x5', with: 'wrong'
  #       fill_in 'x6', with: 'wrong'
  #     end
  #     click_button 'Submit Answer'
  #     wait_for_ajax
  #     expect(page).to have_content "Incorrect,"
  #     expect(page).to have_content "Exp: 100 / #{lesson.pass_experience} Lvl 1"
  #     click_link 'Next question'
  #     wait_for_ajax
  #     if page.has_content?("question text 5")
  #       fill_in 'x1', with: '11'
  #       fill_in 'x2', with: '22'
  #     end
  #     if page.has_content?("question text 6")
  #       fill_in 'x3', with: '33'
  #       fill_in 'x4', with: '44'
  #     end
  #     if page.has_content?("question text 7")
  #       fill_in 'x5', with: '55'
  #       fill_in 'x6', with: '66'
  #     end
  #     click_button 'Submit Answer'
  #     wait_for_ajax
  #     expect(page).to have_content "Correct!"
  #     expect(page).to have_content "Exp: 200 / #{lesson.pass_experience} Lvl 1"
  #   end
  # end
  #
  # context 'Topic mixture of multiple choice and submission questions' do
  #   scenario 'Getting a submit correct and a choice correct' do
  #     topic.questions = [question_4,question_5]
  #     topic.save
  #     sign_in student
  #     visit "/units/#{ unit.id }"
  #     click_link "Chapter 1"
  #     wait_for_ajax
  #     click_link "Chapter Questions"
  #     wait_for_ajax
  #     if page.has_content?("question text 4")
  #       page.choose("choice-#{choice_8.id}")
  #     end
  #     if page.has_content?("question text 5")
  #       fill_in 'x1', with: '11'
  #       fill_in 'x2', with: '22'
  #     end
  #     click_button 'Submit Answer'
  #     wait_for_ajax
  #     expect(page).to have_content "Correct!"
  #     expect(page).to have_content "Exp: 100 / #{lesson.pass_experience} Lvl 1"
  #     click_link 'Next question'
  #     wait_for_ajax
  #     if page.has_content?("question text 4")
  #       page.choose("choice-#{choice_8.id}")
  #     end
  #     if page.has_content?("question text 5")
  #       fill_in 'x1', with: '11'
  #       fill_in 'x2', with: '22'
  #     end
  #     click_button 'Submit Answer'
  #     wait_for_ajax
  #     expect(page).to have_content "Correct!"
  #     expect(page).to have_content "Exp: 225 / #{lesson.pass_experience} Lvl 1"
  #   end
  #
  #   scenario 'Getting a choice correct submit wrong submit correct' do
  #     topic.questions = [question_4,question_5,question_6]
  #     topic.save
  #     sign_in student
  #     visit "/units/#{ unit.id }"
  #     click_link "Chapter 1"
  #     wait_for_ajax
  #     click_link "Chapter Questions"
  #     wait_for_ajax
  #     if page.has_content?("question text 4")
  #       page.choose("choice-#{choice_8.id}")
  #     end
  #     if page.has_content?("question text 5")
  #       fill_in 'x1', with: '11'
  #       fill_in 'x2', with: '22'
  #     end
  #     if page.has_content?("question text 6")
  #       fill_in 'x3', with: '33'
  #       fill_in 'x4', with: '44'
  #     end
  #     click_button 'Submit Answer'
  #     wait_for_ajax
  #     expect(page).to have_content "Correct!"
  #     expect(page).to have_content "Exp: 100 / #{lesson.pass_experience} Lvl 1"
  #     click_link 'Next question'
  #     wait_for_ajax
  #     if page.has_content?("question text 4")
  #       page.choose("choice-#{choice_7.id}")
  #     end
  #     if page.has_content?("question text 5")
  #       fill_in 'x1', with: 'wrong'
  #       fill_in 'x2', with: 'wrong'
  #     end
  #     if page.has_content?("question text 6")
  #       fill_in 'x3', with: 'wrong'
  #       fill_in 'x4', with: 'wrong'
  #     end
  #     click_button 'Submit Answer'
  #     wait_for_ajax
  #     expect(page).to have_content "Incorrect,"
  #     expect(page).to have_content "Exp: 100 / #{lesson.pass_experience} Lvl 1"
  #     click_link 'Next question'
  #     wait_for_ajax
  #     if page.has_content?("question text 4")
  #       page.choose("choice-#{choice_8.id}")
  #     end
  #     if page.has_content?("question text 5")
  #       fill_in 'x1', with: '11'
  #       fill_in 'x2', with: '22'
  #     end
  #     if page.has_content?("question text 6")
  #       fill_in 'x3', with: '33'
  #       fill_in 'x4', with: '44'
  #     end
  #     click_button 'Submit Answer'
  #     wait_for_ajax
  #     expect(page).to have_content "Correct!"
  #     expect(page).to have_content "Exp: 200 / #{lesson.pass_experience} Lvl 1"
  #   end
  # end
end
