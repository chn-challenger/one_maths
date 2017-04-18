feature 'tester' do
  let!(:course) { create_course }
  let!(:unit)   { create_unit course }
  let!(:topic)  { create_topic unit }
  let!(:lesson) { create_lesson topic, 1, 'Published' }
  let!(:admin)  { create_admin }
  let!(:student) { create_student }
  let!(:tester) { create_tester(1) }
  let!(:question_1) { create_question(1) }
  let!(:choice_1) { create_choice(question_1, 1, false) }
  let!(:choice_2) { create_choice(question_1, 2, true) }
  let!(:question_2) { create_question(2) }
  let!(:choice_3) { create_choice(question_2, 3, false) }
  let!(:choice_4) { create_choice(question_2, 4, true) }
  let!(:question_3) { create_question(3) }
  let!(:choice_5) { create_choice(question_3, 5, false) }
  let!(:choice_6) { create_choice(question_3, 6, true) }

  let!(:question_4) { create_question(4) }
  let!(:answer_1) { create_answer(question_4, 1) }
  let!(:answer_2) { create_answer(question_4, 2) }
  let!(:question_5) { create_question(5) }
  let!(:answer_3) { create_answer(question_5, 3) }
  let!(:question_6) { create_question(6) }
  let!(:answer_6) { create_answers(question_6, [["a=",'10=>x=>5'], ['b=','100=z or z=2/3'],['c=','-19=>x']], 'inequality') }
  let!(:question_7) { create_question(7) }
  let!(:answer_7) { create_answers(question_7, [["a=",'(5/2, 2.34)'], ['b=','(-3, -2.42)'], ['c=','(-9/11, 2)']], 'coordinates') }
  let!(:question_8) { create_question(8) }
  let!(:answer_8) { create_answers(question_8, [['a=','InfLection PoINT'], ['b=','maximum']], 'words') }

  let!(:question_16) { create_question_with_order(16, 'c1') }
  let!(:answer_16) { create_answer(question_16, 16) }
  let!(:question_15) { create_question_with_order(15, 'c1') }
  let!(:answer_15) { create_answer(question_15, 15) }
  let!(:question_12) { create_question_with_order(12, 'd1') }
  let!(:answer_12) { create_answer(question_12, 12) }
  let!(:question_11) { create_question_with_order(11, 'd1') }
  let!(:answer_11) { create_answer(question_11, 11) }
  let!(:question_14) { create_question_with_order(14, 'b1') }
  let!(:answer_14) { create_answer(question_14, 14) }
  let!(:question_13) { create_question_with_order(13, 'b1') }
  let!(:answer_13) { create_answer(question_13, 13) }

  let!(:question_21) { create_question_with_order(21, 'a1') }
  let!(:answer_21) { create_answer_with_two_values(question_21, 21, 1.33322, 2) }
  let!(:tags_21) { add_tags(question_21, 1) }
  let!(:question_22) { create_question_with_order(22, 'b1') }
  let!(:answer_22) { create_answer_with_two_values(question_22, 22, -1.23, -2) }
  let!(:tags_22) { add_tags(question_22, 2) }

  let!(:question_23) { create_question_with_order(23, 'b1') }
  let!(:answer_23) do
    create_answers(question_23, [['x=', '+5,-8'], ['y=', '6'],
                                 ['z=', '7'], ['w=', '8']])
  end
  let!(:question_24) { create_question_with_order(24, 'b1') }
  let!(:answer_24) do
    create_answers(question_24, [['a=', '+5,-8'], ['b=', '6'],
                                 ['c=', '7']])
  end
  let!(:question_25) { create_question_with_order(25, 'b1') }
  let!(:answer_25) { create_answers(question_25, [['a=', '+5,-8,7.1,6.21']]) }
  let!(:question_26) { create_question_with_order(26, 'b1') }
  let!(:answer_26) { create_answers(question_26, [['a=', '+5,-8,6.21'], ['b=', '7'], ['c=', '4']]) }

  context '#view' do
    before(:each) do
      lesson.questions = [question_23]
      lesson.save
    end

    scenario 'student can\'t view options on question card', js: true do
      sign_in student
      visit "/units/#{unit.id}"
      find("#chapter-collapsable-#{topic.id}").trigger('click')
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      wait_for_ajax
      expect(page).to have_content 'question text 23'
      expect(page).not_to have_css "#reset-question-#{question_23.id}"
      expect(page).not_to have_css "#flag-question-#{question_23.id}"
    end

    scenario 'tester can view options on question card', js: true do
      sign_in tester
      visit "/units/#{unit.id}"
      find("#chapter-collapsable-#{topic.id}").trigger('click')
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      wait_for_ajax
      expect(page).to have_content 'question text 23'
      expect(page).to have_css "#view-flag-#{question_23.id}"
      expect(page).to have_css "#reset-question-#{question_23.id}"
      expect(page).to have_css "#flag-question-#{question_23.id}"
    end

    scenario 'tester can view side menu to view all flagged questions' do
      flag_question(tester, question_23)
      sign_in tester
      visit courses_path
      expect(page).to have_content 'View flagged questions'
      visit "/units/#{unit.id}"
      expect(page).to have_content 'View flagged questions'
    end

    scenario 'tester can view all of his flagged questions' do
      flag_question(tester, [question_23, question_24])
      sign_in tester
      visit courses_path
      click_link 'View flagged questions'
      expect(page).to have_content question_23.question_text
      expect(page).to have_content question_24.question_text
    end

    scenario 'student can\'t view flagged questions page' do
      sign_in student
      visit '/questions/flags'
      expect(page).to have_content 'You are not authorized to access this page.'
    end

    scenario 'tester can view a flagged question' do
      flag_question(tester, [question_23, question_24])
      sign_in tester
      visit courses_path
      click_link 'View flagged questions'
      click_link "view-flag-#{question_23.id}"
      expect(page).to have_content question_23.solution
      expect(page).to have_content question_23.question_text
      expect(page).to have_content question_23.answers.last.label
      expect(page).to have_content question_23.answers.last.solution
      expect(page).to have_link 'Edit question'
      expect(page).to have_link 'Reset Question'
      expect(page).to have_link 'Edit answer'
    end

    scenario 'tester can view own answered question', js: true do
      srand(100)
      flag_question(tester, [question_23, question_24])
      sign_in tester
      visit "/units/#{unit.id}"
      find("#chapter-collapsable-#{topic.id}").trigger('click')
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      wait_for_ajax
      expect(page).to have_content 'question text 23'
      fill_in 'x=', with: '+5,-8'
      fill_in 'y=', with: '1/2'
      fill_in 'z=', with: '7'
      fill_in 'w=', with: '9'
      click_button 'Submit Answers'
      wait_for_ajax
      visit courses_path
      find(:xpath, "//a[@href='/questions/flags']").trigger('click')
      click_link "view-flag-#{question_23.id}"
      expect(page).to have_content 'Correct: false'
      expect(page).to have_content 'w=9 z=7 y=1/2 x=+5,-8'
    end

    scenario 'tester can\'t view Delete Question button' do
      flag_question(tester, [question_23, question_24])
      sign_in tester
      visit courses_path
      click_link 'View flagged questions'
      click_link "view-flag-#{question_23.id}"
      expect(page).not_to have_link 'Delete question'
    end
  end

  context '#flag' do
    before(:each) do
      lesson.questions = [question_23]
      lesson.save
    end

    scenario 'tester can flag a question', js: true do
      sign_in tester
      visit courses_path
      expect(page).to have_content
      visit "/units/#{unit.id}"
      find("#chapter-collapsable-#{topic.id}").trigger('click')
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      wait_for_ajax
      expect(page).not_to have_link 'View flagged questions'
      click_link "flag-question-#{question_23.id}"
      expect(page).to have_link 'View flagged questions'
      find(:xpath, "//a[@href='/questions/flags']").trigger('click')
      expect(page).to have_content question_23.question_text
    end

    scenario 'tester can unflag a question' do
      flag_question(tester, question_23)
      sign_in tester
      visit courses_path
      click_link 'View flagged questions'
      click_link "view-flag-#{question_23.id}"
      click_link "remove-flag-#{question_23.id}"
      expect(current_path).to eq '/questions/flags'
      expect(page).not_to have_link "view-flag-#{question_23.id}"
    end
  end

  context '#reset_question' do
    before(:each) do
      create_ans_q(tester, question_23, correctness=1, streak_mtp=1, lesson)
      flag_question(tester, question_23)
      lesson.questions = [question_23]
      lesson.save
    end

    scenario 'tester deletes answered question' do
      sign_in tester
      visit courses_path
      click_link 'View flagged questions'
      click_link "view-flag-#{question_23.id}"
      expect(AnsweredQuestion.count).to eq 1
      click_link "reset-question-#{question_23.id}"
      expect(AnsweredQuestion.count).to eq 0
    end
  end

end
