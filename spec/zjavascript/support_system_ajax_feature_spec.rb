feature 'js_support_system', js: true do
  let!(:course) { create_course  }
  let!(:unit)   { create_unit course }
  let!(:topic)  { create_topic unit }
  let!(:lesson) { create_lesson topic, 1, 'Published' }
  let!(:admin)  { create_admin   }
  let!(:student){ create_student }

  let!(:question_25){create_question_with_order(25,"a1")}
  let!(:answer_25){create_answers(question_25,[['a=','+5,-8,7.1,6.21']])}
  let!(:question_26){create_question_with_order(26,"b1")}
  let!(:answer_26){create_answers(question_26,[['a=','+5,-8,6.21'],['b=','7'],['c=','4']])}
  let!(:question_27){create_question_with_order(27,"c1")}
  let!(:answer_27){create_answers(question_27,[['a=','+6,-7, 0.2, 3, -1']])}
  let!(:question_28){create_question_with_order(28,"d1")}
  let!(:answer_28){create_answers(question_28,[['a=','+5,-1/8'],['b=','12']])}
  let!(:question_29){create_question_with_order(29,"e1")}
  let!(:answer_29){create_answers(question_29,[['a=','+3,-5, -1/3, 2/5, 1']])}


  context 'report a question' do
    scenario 'student answeres questions and submits a ticket' do
      lesson.questions = [question_25, question_26, question_27, question_28, question_29]
      lesson.save
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      fill_in "a=", with: '+5,-8,7.1,6.21'
      click_button 'Submit Answers'
      wait_for_ajax
      expect(page).to have_content "Correct! You have earnt 100"
      expect(page).to have_content topic_exp_bar(student, topic, 100)
      expect(page).to have_content "100 / 750 Pass"
      expect(page).to have_link "bug-report-q#{question_25.id}"
      click_link 'Next question'

      wait_for_ajax
      fill_in "a=", with: '+5,-8,7.1,6.21'
      fill_in 'b=', with: '7'
      fill_in 'c=', with: '4'
      click_button 'Submit Answers'
      wait_for_ajax
      expect(page).to have_content "Correct! You have earnt 125"
      expect(page).to have_content topic_exp_bar(student, topic, 225)
      expect(page).to have_content "225 / 750 Pass"
      expect(page).to have_link "bug-report-q#{question_26.id}"
      click_link 'Next question'

      wait_for_ajax
      fill_in "a=", with: '+6,-7, 0.2, -3, 1'
      click_button 'Submit Answers'
      wait_for_ajax
      expect(page).to have_content "Partially correct! You have earnt 90"
      expect(page).to have_content topic_exp_bar(student, topic, 315)
      expect(page).to have_content "315 / 750 Pass"
      expect(page).to have_link "bug-report-q#{question_27.id}"

      click_link "bug-report-q#{question_27.id}"
      fill_in 'Description', with: 'Should be getting a 100% correctness on this question.'
      click_button 'Create Ticket'
      wait_for_ajax
      click_link "Chapter 1"
      find("#lesson-collapsable-#{lesson.id}").trigger('click')

      fill_in "a=", with: '+5,-1/8'
      fill_in 'b=', with: '12'
      click_button 'Submit Answers'
      wait_for_ajax
      expect(page).to have_content "Correct! You have earnt 130"
      expect(page).to have_content topic_exp_bar(student, topic, 445)
      expect(page).to have_content "445 / 750 Pass"
      expect(page).to have_link "bug-report-q#{question_28.id}"
      click_link 'Next question'

      wait_for_ajax
      fill_in "a=", with: '+3,-5, -1/3'
      click_button 'Submit Answers'
      wait_for_ajax
      expect(page).to have_content "Partially correct! You have earnt 93 "
      expect(page).to have_content topic_exp_bar(student, topic, 538)
      expect(page).to have_content "538 / 750 Pass"
      expect(page).to have_link "bug-report-q#{question_29.id}"

      expect(StudentLessonExp.last.streak_mtp).to eq 1.33
      expect(StudentLessonExp.last.exp).to eq 538

      sign_out

      sign_in admin
      click_link 'Tickets'
      click_link 'View 1'
      check 'award_exp'
      fill_in 'Correctness', with: '1'
      click_button 'Close Ticket'

      expect(StudentLessonExp.last.streak_mtp).to eq 1.6
      expect(StudentLessonExp.last.exp).to eq 670

      sign_out

      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      expect(page).to have_content topic_exp_bar(student, topic, 670)
      expect(page).to have_content "670 / 750 Pass"
    end
  end
end
