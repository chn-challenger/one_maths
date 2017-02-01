feature 'js_lessons', js: true do
  let!(:course) { create_course  }
  let!(:unit)   { create_unit course }
  let!(:topic)  { create_topic unit }
  let!(:lesson) { create_lesson topic, 1, 'Published' }
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
  let!(:question_5){create_question(5)}
  let!(:answer_1){create_answer(question_5,1)}
  let!(:answer_2){create_answer(question_5,2)}
  let!(:question_6){create_question(6)}
  let!(:answer_3){create_answer(question_6,3, nil, nil, "0")}
  let!(:answer_4){create_answer(question_6,4)}
  let!(:question_7){create_question(7)}
  let!(:answer_5){create_answer(question_7,5, nil, nil, "Custom Hint")}
  let!(:answer_6){create_answer(question_7,6)}
  let!(:question_9){create_question_with_order(9,"b1")}
  let!(:answer_9){create_answer(question_9,9)}
  let!(:question_10){create_question_with_order(10,"z1")}
  let!(:answer_10){create_answer(question_10,10)}
  let!(:question_11){create_question_with_order(11,"z1")}
  let!(:answer_11){create_answer(question_11,11)}

  let!(:question_25){create_question_with_order(25,"b1")}
  let!(:answer_25){create_answers(question_25,[['a=','+5,-8,7.1,6.21']])}
  let!(:question_26){create_question_with_order(26,"b1")}
  let!(:answer_26){create_answers(question_26,[['a=','+5,-8,6.21'],['b=','7'],['c=','4']])}
  let!(:question_27){create_question_with_order(27,"c1")}
  let!(:answer_27){create_answers(question_27,[['a=','+6,-7, 0.2, 3, -1']])}

  context 'Lesson questions hint displayed correctly' do
    before(:each) do
      hints = ['Global Hint 0', 'Global Hint 1']
      stub_const('AnswersHelper::ANSWER_HINTS', hints)
      # allow_any_instance_of(AnswersHelper).to receive(:load_hints).and_return(hints)
    end

    scenario 'global hint' do
      lesson.questions = [question_6]
      lesson.save
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      click_button 'Submit Answers'
      wait_for_ajax
      expect(page).to have_content "Global Hint 0"
    end

    scenario 'custom hint' do
      lesson.questions = [question_7]
      lesson.save
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      click_button 'Submit Answers'
      wait_for_ajax
      expect(page).to have_content "Custom Hint"
    end
  end

  context 'Lesson submission partially correct answers' do
    scenario 'Lesson partially correct answer eg1' do
      lesson.questions = [question_25]
      lesson.save
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      fill_in "a=", with: '6.21'
      click_button 'Submit Answers'
      wait_for_ajax
      expect(page).to have_content "Partially correct! You have earnt 25"
      expect(page).to have_content topic_exp_bar(student, topic, 25)
      expect(page).to have_content "25 / 100 Pass"
    end

    scenario 'Lesson partially correct answer eg2' do
      lesson.questions = [question_26]
      lesson.save
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      fill_in "a=", with: '6.21,5'
      fill_in 'b=', with: '3'
      fill_in 'c=', with: '2'
      click_button 'Submit Answers'
      wait_for_ajax
      expect(page).to have_content "Partially correct! You have earnt 22"
      expect(page).to have_content topic_exp_bar(student, topic, 22)
      expect(page).to have_content "22 / 100 Pass"
    end
  end

  context 'Reset incorrectly answered questions' do
    scenario 'submit answer question reset' do
      lesson.questions = [question_25,question_27]
      lesson.save
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      fill_in 'a', with: '5, -8, 7.1, 6.21'
      click_button 'Submit Answer'
      wait_for_ajax
      click_link 'Next question'
      wait_for_ajax
      fill_in 'a', with: '22, 33, 44, 100, 10'
      click_button 'Submit Answer'
      wait_for_ajax
      click_link 'Next question'
      wait_for_ajax
      expect(page).to have_content 'question text 27'
      expect(student.question_resets.last.question_id).to eq question_27.id
    end
  end

  context 'Lesson submission field validation' do
    scenario 'prevent empty field submission' do
      lesson.questions = [question_26]
      lesson.save
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      click_button 'Submit Answers'
      wait_for_ajax
      expect(page).to have_content topic_exp_bar(student, topic, 0)
      expect(page).to have_content "0 / 100 Pass"
      expect(page).not_to have_content "Solution"
    end

    scenario 'two empty fields one filled in' do
      lesson.questions = [question_26]
      lesson.save
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      fill_in "a=", with: '6.211,5'
      click_button 'Submit Answers'
      wait_for_ajax
      expect(page).to have_content topic_exp_bar(student, topic, 0)
      expect(page).to have_content "0 / 100 Pass"
      expect(page).not_to have_content "Solution"
    end

    scenario 'one empty fields two filled in' do
      lesson.questions = [question_26]
      lesson.save
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      fill_in "a=", with: '6.211,5'
      fill_in 'b=', with: '7'
      click_button 'Submit Answers'
      wait_for_ajax
      expect(page).to have_content topic_exp_bar(student, topic, 0)
      expect(page).to have_content "0 / 100 Pass"
      expect(page).not_to have_content "Solution"
    end

    scenario 'all fields filled in' do
      lesson.questions = [question_26]
      lesson.save
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      fill_in "a=", with: '+5,-8,6.21'
      fill_in 'b=', with: '7'
      fill_in 'c=', with: '4'
      click_button 'Submit Answers'
      wait_for_ajax
      expect(page).to have_content topic_exp_bar(student, topic, 0)
      expect(page).to have_content "100 / 100 Pass"
      expect(page).to have_content "Solution"
    end

  end

  context 'Lesson multiple choice questions' do
    scenario 'Getting two in a row correct' do
      lesson.questions = [question_1,question_2,question_3]
      lesson.save
      srand(105)
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      page.choose("choice-#{choice_2.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 0)
      expect(page).to have_content "100 / 100 Pass"
      click_link 'Next question'
      wait_for_ajax
      page.choose("choice-#{choice_6.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 0)
      expect(page).to have_content "100 / 100 Pass"
    end

    scenario 'Getting one right one wrong and one right' do
      lesson.questions = [question_1,question_2,question_3,question_4]
      lesson.save
      srand(109)
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      page.choose("choice-#{choice_6.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 0)
      expect(page).to have_content "100 / 100 Pass"
      click_link 'Next question'
      wait_for_ajax
      expect(page).to have_content "100 xp + 25 xp streak bonus"
      page.choose("choice-#{choice_3.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Incorrect"
      expect(page).to have_content topic_exp_bar(student, topic, 0)
      expect(page).to have_content "100 / 100 Pass"
      click_link 'Next question'
      wait_for_ajax
      expect(page).to have_content "100 xp + 0 xp streak bonus"
      page.choose("choice-#{choice_8.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 0)
      expect(page).to have_content "100 / 100 Pass"
    end

    scenario 'Out of questions' do
      lesson.questions = [question_1]
      lesson.save
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      page.choose("choice-#{choice_2.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 0)
      expect(page).to have_content "100 / 100 Pass"
      click_link 'Next question'
      wait_for_ajax
      expect(page).to have_content "You have attempted all the questions"
    end
  end

  context 'Lesson answer submission questions' do
    scenario 'Getting a submit answer question correct' do
      lesson.questions = [question_5,question_6]
      lesson.save
      srand(120)
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      fill_in 'x3', with: '33'
      fill_in 'x4', with: '44'
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 0)
      expect(page).to have_content "100 / 100 Pass"
    end

    scenario 'Getting two submit answer question correct' do
      lesson.questions = [question_5,question_6]
      lesson.save
      srand(106)
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      fill_in 'x1', with: '11'
      fill_in 'x2', with: '22'
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 0)
      expect(page).to have_content "100 / 100 Pass"
      click_link 'Next question'
      wait_for_ajax
      fill_in 'x3', with: '33'
      fill_in 'x4', with: '44'
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 0)
      expect(page).to have_content "100 / 100 Pass"
    end

    scenario 'submit answer questions right wrong right' do
      lesson.questions = [question_5,question_6,question_7]
      lesson.save
      srand(105)
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      fill_in 'x1', with: '11'
      fill_in 'x2', with: '22'
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 0)
      expect(page).to have_content "100 / 100 Pass"
      click_link 'Next question'
      wait_for_ajax
      fill_in 'x3', with: 'wrong'
      fill_in 'x4', with: 'wrong'
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Incorrect,"
      expect(page).to have_content topic_exp_bar(student, topic, 0)
      expect(page).to have_content "100 / 100 Pass"
      click_link 'Next question'
      wait_for_ajax
      fill_in 'x5', with: '55'
      fill_in 'x6', with: '66'
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 0)
      expect(page).to have_content "100 / 100 Pass"
    end
  end

  context 'Lesson mixture of multiple choice and submission questions' do
    scenario 'Getting a submit correct and a choice correct' do
      lesson.questions = [question_4,question_5]
      lesson.save
      srand(101)
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      fill_in 'x1', with: '11'
      fill_in 'x2', with: '22'
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 0)
      expect(page).to have_content "100 / 100 Pass"
      click_link 'Next question'
      wait_for_ajax
      page.choose("choice-#{choice_8.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 0)
      expect(page).to have_content "100 / 100 Pass"
    end

    scenario 'Getting a choice correct submit wrong submit correct' do
      lesson.questions = [question_4,question_5,question_6]
      lesson.save
      srand(108)
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      fill_in 'x1', with: '11'
      fill_in 'x2', with: '22'
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 0)
      expect(page).to have_content "100 / 100 Pass"
      click_link 'Next question'
      wait_for_ajax
      page.choose("choice-#{choice_7.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Incorrect,"
      expect(page).to have_content topic_exp_bar(student, topic, 0)
      expect(page).to have_content "100 / 100 Pass"
      click_link 'Next question'
      wait_for_ajax
      fill_in 'x3', with: '33'
      fill_in 'x4', with: '44'
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 0)
      expect(page).to have_content "100 / 100 Pass"
    end
  end

  context 'lesson exp capped at passing exp' do
    scenario 'Topic exp does not increase if lesson pass_exp has been reached' do
      lesson.questions = [question_9,question_10,question_11]
      lesson.save
      srand(108)
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      fill_in 'x9', with: '99'
      fill_in 'x9', with: '99'
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 100)
      expect(page).to have_content "100 / 225 Pass"
      click_link 'Next question'
      wait_for_ajax
      fill_in 'x11', with: '1111'
      fill_in 'x11', with: '1111'
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 0)
      expect(page).to have_content "225 / 225 Pass"
      click_link 'Next question'
      wait_for_ajax
      fill_in 'x10', with: '1010'
      fill_in 'x10', with: '1010'
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 0)
      expect(page).to have_content "225 / 225 Pass"
    end
  end
end
