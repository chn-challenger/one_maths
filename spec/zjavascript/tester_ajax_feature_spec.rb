feature 'js_tester', js: true do
  let!(:course) { create_course  }
  let!(:unit)   { create_unit course }
  let!(:topic)  { create_topic unit }
  let!(:lesson) { create_lesson topic, 1, 'Published' }
  let!(:admin)  { create_admin   }
  let!(:student){ create_student }
  let!(:tester) { create_tester(1) }
  let!(:tester_2) { create_tester(2) }

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


  context 'flag questions' do
    before(:each) do
      lesson.questions = [question_25, question_26, question_27, question_28, question_29]
      lesson.save
      sign_in tester
    end

    scenario 'tester submits answers and flags questions' do
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      fill_in "a=", with: '+5,-8,7.1,6.21'
      click_button 'Submit Answers'
      wait_for_ajax
      expect(page).to have_content "Correct! You have earnt 100"
      expect(page).to have_link "flag-question-#{question_25.id}"
      click_link "flag-question-#{question_25.id}"

      wait_for_ajax
      click_link "Chapter 1"
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      fill_in "a=", with: '+5,-8,7.1,6.21'
      fill_in 'b=', with: '7'
      fill_in 'c=', with: '4'
      click_button 'Submit Answers'
      wait_for_ajax
      expect(page).to have_content "Correct! You have earnt 125"
      expect(page).to have_link "flag-question-#{question_26.id}"
      click_link "flag-question-#{question_26.id}"

      wait_for_ajax
      click_link "Chapter 1"
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      fill_in "a=", with: '+6,-7, 0.2, -3, 1'
      click_button 'Submit Answers'
      wait_for_ajax
      expect(page).to have_content "Partially correct! You have earnt 90"
      expect(page).to have_link "flag-question-#{question_27.id}"
      click_link "flag-question-#{question_27.id}"
    end
  end

  context 'reset answer' do
    before(:each) do
      lesson.questions = [question_25, question_26, question_28]
      lesson.save
      sign_in tester_2
    end

    scenario 'tester resets answered question for second question' do
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      fill_in "a=", with: '+5,-8,7.1,6.21'
      click_button 'Submit Answers'
      wait_for_ajax
      expect(page).to have_content "Correct! You have earnt 100"
      expect(page).to have_link "reset-question-#{question_25.id}"
      click_link 'Next question'

      wait_for_ajax
      fill_in "a=", with: '+5,-8,7.1,6.21'
      fill_in 'b=', with: '7'
      fill_in 'c=', with: '4'
      click_button 'Submit Answers'
      wait_for_ajax
      expect(page).to have_content "Correct! You have earnt 125"
      expect(page).to have_link "reset-question-#{question_26.id}"
      expect(AnsweredQuestion.find_by(question_id: question_26.id, user_id: tester_2.id).blank?).to eq false
      click_link "reset-question-#{question_26.id}"

      expect(AnsweredQuestion.find_by(question_id: question_26.id, user_id: tester_2.id).blank?).to eq true

      wait_for_ajax
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      expect(page).to have_content question_26.question_text
      fill_in "a=", with: '+5,-8,7.1,6.21'
      fill_in 'b=', with: '7'
      fill_in 'c=', with: '4'
      click_button 'Submit Answers'
      wait_for_ajax
      expect(page).to have_content "Correct! You have earnt 150"
      expect(page).to have_link "reset-question-#{question_26.id}"
    end
  end

end
