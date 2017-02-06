feature 'js_topics', js: true do
  let!(:course) { create_course  }
  let!(:unit)   { create_unit course }
  let!(:topic)  { create_topic unit }
  let!(:lesson) { create_lesson topic, 1, 'Published' }
  # let!(:lesson_2) { create_lesson topic, 2, 'Published'}
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
  let!(:answer_3){create_answer(question_6,3, nil, nil, "1")}
  let!(:answer_4){create_answer(question_6,4)}
  let!(:question_7){create_question(7)}
  let!(:answer_5){create_answer(question_7,5, nil, nil, "Custom Hint")}
  let!(:answer_6){create_answer(question_7,6)}

  let!(:question_8) { create_question_with_lvl(8, 2) }
  let!(:choice_15){create_choice(question_8,15,false)}
  let!(:choice_16){create_choice(question_8,16,true)}

  let!(:question_9) { create_question_with_lvl(9, 3) }
  let!(:choice_17){create_choice(question_9,17,false)}
  let!(:choice_18){create_choice(question_9,18,true)}

  let!(:question_10) { create_question_with_lvl(10, 4) }
  let!(:choice_19){create_choice(question_10,19,false)}
  let!(:choice_20){create_choice(question_10,20,true)}


  let!(:question_25){create_question_with_order(25,"b1")}
  let!(:answer_25){create_answers(question_25,[['a=','+5,-8,7.1,6.21']])}
  let!(:question_26){create_question_with_order(26,"b1")}
  let!(:answer_26){create_answers(question_26,[['a=','+5,-8,6.21'],['b=','7'],['c=','4']])}
  let!(:question_27){create_question_with_order(27,"c1")}
  let!(:answer_27){create_answers(question_27,[['a=','+6,-7, 0.2, 3, -1']])}
  let!(:question_28){create_question_with_order(28,"d1")}
  let!(:answer_28){create_answers(question_28,[['a=','+5,-1/8'],['b=','12']])}
  let!(:lesson_exp) { create_student_lesson_exp(student,lesson,100) }
  let!(:lesson_exp_2) { create_student_lesson_exp(student_2,lesson,50) }
  let!(:topic_exp) { create_student_topic_exp(student, topic, 100) }

  context 'questions visibility' do
    before(:each) do
      lesson.questions = [question_25, question_26]
      lesson.save
      create_ans_q(student, question_25, 1, 1, lesson)
      create_ans_q(student, question_26, 1, 1, lesson)
      topic.questions = [question_28]
      topic.save
    end

    scenario 'can\'t see topic questions unless all lessons are complete' do
      lesson.questions << [question_25, question_26]
      sign_in student_2
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      click_link "Chapter Questions"
      wait_for_ajax
      expect(page).to have_content 'You need to complete all lessons to see Chapter questions.'
    end

    scenario 'can see topic questions when all lessons are complete' do
      lesson.questions << [question_25]
      lesson.save
      srand(102)
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      click_link "Chapter Questions"
      wait_for_ajax
      expect(page).not_to have_content 'You need to complete all lessons to see Chapter questions.'
      expect(page).to have_content question_28.question_text
    end
  end

  context 'Topic question hints are displayed' do
    before(:each) do
      hints = ['Global Hint 0', 'Global Hint 1']
      stub_const('AnswersHelper::ANSWER_HINTS', hints)

      lesson.questions = [question_25, question_26]
      lesson.save
      create_ans_q(student, question_25, 1, 1, lesson)
      create_ans_q(student, question_26, 1, 1, lesson)
    end

    scenario 'global hint' do
      topic.questions << [question_6]
      topic.save
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      click_link "Chapter Questions"
      wait_for_ajax
      expect(page).to have_content "Global Hint 1"
    end

    scenario 'custom hint' do
      topic.questions << [question_7]
      topic.save
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      click_link "Chapter Questions"
      wait_for_ajax
      expect(page).to have_content "Custom Hint"
    end
  end

  context 'select question based on streak_mtp' do
      before(:each) do
        allow_any_instance_of(Topic).to receive(:load_config).and_return(
                                        { 'reward_mtp' => 0.3,
                                          'lower_level' => 1,
                                          'upper_level' => 0.6,
                                          'lower_min' => 0.2,
                                          'upper_min' => 0.25 })

        lesson.questions = [question_25, question_26]
        lesson.save
        create_ans_q(student, question_25, 1, 1, lesson)
        create_ans_q(student, question_26, 1, 1, lesson)
      end

    scenario 'question lvl 1 is selected for streak_mtp of 1.0' do
      topic.questions << [question_1, question_8, question_9]
      topic.save
      srand(103)
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      click_link "Chapter Questions"
      wait_for_ajax
      expect(page).to have_content question_1.question_text
    end

    scenario 'selects questions level 1, 2 and 3' do
      topic.questions << [question_1, question_8, question_9]
      topic.save
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      click_link "Chapter Questions"
      expect(page).to have_content question_1.question_text
      page.choose("choice-#{choice_2.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 70)
      click_link 'Next question'
      wait_for_ajax
      expect(page).to have_content question_8.question_text
      page.choose("choice-#{choice_16.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      click_link 'Next question'
      wait_for_ajax
      expect(page).to have_content question_9.question_text
    end
  end

  context 'apply reward_mtp based on question lvl' do
      before(:each) do
        lesson.questions = [question_25, question_26]
        lesson.save
        create_ans_q(student, question_25, 1, 1, lesson)
        create_ans_q(student, question_26, 1, 1, lesson)
      end

    scenario 'decrease exp by 30% when question lvl is 1' do
      topic.questions << [question_1, question_8, question_9]
      topic.save
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      click_link "Chapter Questions"
      wait_for_ajax
      page.choose("choice-#{choice_2.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 70)
      click_link 'Next question'
      wait_for_ajax
      page.choose("choice-#{choice_16.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 195)
      click_link 'Next question'
      wait_for_ajax
      page.choose("choice-#{choice_18.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 190)
    end
  end

  context 'reset questions if questions pools are exhausted' do
    before(:each) do
      lesson.questions = [question_5, question_4, question_1]
      lesson.save
      create_ans_q(student, question_5, 1, 1, lesson)
      create_ans_q(student, question_4, 1, 1, lesson)
    end

    scenario 'resets lesson question when all questions exhausted' do
      topic.questions = [question_2,question_3]
      topic.save
      srand(102)
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      click_link "Chapter Questions"
      wait_for_ajax
      page.choose("choice-#{choice_1.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Incorrect"
      expect(page).to have_content topic_exp_bar(student, topic, 0)
      click_link 'Next question'
      wait_for_ajax
      expect(page).to have_content "100 xp + 0 xp streak bonus"
      page.choose("choice-#{choice_6.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct"
      expect(page).to have_content topic_exp_bar(student, topic, 70)
      click_link 'Next question'
      wait_for_ajax
      expect(page).to have_content "100 xp + 25 xp streak bonus"
      page.choose("choice-#{choice_4.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 157)
      click_link 'Next question'
      wait_for_ajax
      expect(page).to have_content question_1.question_text
    end

    scenario 'resets topic questions when all questions exhausted' do
      topic.questions = [question_2,question_3]
      topic.save
      srand(102)
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      click_link "Chapter Questions"
      wait_for_ajax
      page.choose("choice-#{choice_2.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 70)
      click_link 'Next question'
      wait_for_ajax
      expect(page).to have_content "100 xp + 25 xp streak bonus"
      page.choose("choice-#{choice_5.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Incorrect"
      expect(page).to have_content topic_exp_bar(student, topic, 70)
      click_link 'Next question'
      wait_for_ajax
      expect(page).to have_content "100 xp + 0 xp streak bonus"
      page.choose("choice-#{choice_4.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 140)
      click_link 'Next question'
      wait_for_ajax
      expect(page).to have_content question_3.question_text
    end

    scenario 'no questions reset when none to reset' do
      topic.questions = [question_2,question_3]
      topic.save
      srand(102)
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      click_link "Chapter Questions"
      wait_for_ajax
      page.choose("choice-#{choice_2.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 70)
      click_link 'Next question'
      wait_for_ajax
      expect(page).to have_content "100 xp + 25 xp streak bonus"
      page.choose("choice-#{choice_6.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 157)
      click_link 'Next question'
      wait_for_ajax
      expect(page).to have_content "100 xp + 50 xp streak bonus"
      page.choose("choice-#{choice_4.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 62)
      click_link 'Next question'
      wait_for_ajax
      msg = 'Well done! You have attempted all the questions available'
      expect(page).to have_content msg
    end
  end


  context 'Topic multiple choice questions' do
    before(:each) do
      lesson.questions = [question_25, question_26]
      lesson.save
      create_ans_q(student, question_25, 1, 1, lesson)
      create_ans_q(student, question_26, 1, 1, lesson)
    end

    scenario 'Getting two in a row correct' do
      topic.questions = [question_1,question_2,question_3]
      topic.save
      srand(101)
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      click_link "Chapter Questions"
      wait_for_ajax
      page.choose("choice-#{choice_4.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 70)
      click_link 'Next question'
      wait_for_ajax
      page.choose("choice-#{choice_2.id}")
      click_button 'Submit Answer'
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 157)
    end

    scenario 'Getting one right one wrong and one right' do
      topic.questions = [question_1,question_2,question_3,question_4]
      topic.save
      srand(102)
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      click_link "Chapter Questions"
      wait_for_ajax
      page.choose("choice-#{choice_6.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 70)
      click_link 'Next question'
      wait_for_ajax
      expect(page).to have_content "100 xp + 25 xp streak bonus"
      page.choose("choice-#{choice_3.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Incorrect"
      expect(page).to have_content topic_exp_bar(student, topic, 70)
      click_link 'Next question'
      wait_for_ajax
      expect(page).to have_content "100 xp + 0 xp streak bonus"
      page.choose("choice-#{choice_8.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 140)
    end

    scenario 'Out of questions' do
      topic.questions = [question_1]
      topic.save
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      wait_for_ajax
      click_link "Chapter Questions"
      wait_for_ajax
      page.choose("choice-#{choice_2.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 0)
      click_link 'Next question'
      wait_for_ajax
      expect(page).to have_content "You have attempted all the questions"
    end
  end

  context 'Topic answer submission questions' do
      before(:each) do
        lesson.questions = [question_25, question_26]
        lesson.save
        create_ans_q(student, question_25, 1, 1, lesson)
        create_ans_q(student, question_26, 1, 1, lesson)
      end

    scenario 'Getting a Submit Answer question correct' do
      topic.questions = [question_5,question_6]
      topic.save
      sign_in student
      srand(101)
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      wait_for_ajax
      click_link "Chapter Questions"
      wait_for_ajax
      fill_in 'x3', with: '33'
      fill_in 'x4', with: '44'
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 70)
    end

    scenario 'Getting two Submit Answer question correct' do
      topic.questions = [question_5,question_6]
      topic.save
      srand(101)
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      click_link "Chapter Questions"
      wait_for_ajax
      fill_in 'x3', with: '33'
      fill_in 'x4', with: '44'
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 70)
      click_link 'Next question'
      wait_for_ajax
      fill_in 'x1', with: '11'
      fill_in 'x2', with: '22'
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 157)
    end

    scenario 'Submit Answer questions right wrong right' do
      topic.questions = [question_5,question_6,question_7]
      topic.save
      srand(101)
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      wait_for_ajax
      click_link "Chapter Questions"
      wait_for_ajax
      expect(page).to have_content 'question text 6'
      fill_in 'x3', with: '33'
      fill_in 'x4', with: '44'
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 70)
      click_link 'Next question'
      wait_for_ajax
      fill_in 'x1', with: 'wrong'
      fill_in 'x2', with: 'wrong'
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Incorrect,"
      expect(page).to have_content topic_exp_bar(student, topic, 70)
      click_link 'Next question'
      wait_for_ajax
      fill_in 'x5', with: '55'
      fill_in 'x6', with: '66'
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 140)
    end
  end

  context 'Topic mixture of multiple choice and submission questions' do
      before(:each) do
        lesson.questions = [question_25, question_26]
        lesson.save
        create_ans_q(student, question_25, 1, 1, lesson)
        create_ans_q(student, question_26, 1, 1, lesson)
      end

    scenario 'Getting a submit correct and a choice correct' do
      topic.questions = [question_4,question_5]
      topic.save
      srand(101)
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      wait_for_ajax
      click_link "Chapter Questions"
      wait_for_ajax
      fill_in 'x1', with: '11'
      fill_in 'x2', with: '22'
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 70)
      click_link 'Next question'
      wait_for_ajax
      page.choose("choice-#{choice_8.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 157)
    end

    scenario 'Getting a choice correct submit wrong submit correct' do
      topic.questions = [question_4,question_5,question_6]
      topic.save
      srand(101)
      sign_in student
      visit "/units/#{ unit.id }"
      click_link "Chapter 1"
      wait_for_ajax
      click_link "Chapter Questions"
      wait_for_ajax
      fill_in 'x1', with: '11'
      fill_in 'x2', with: '22'
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 70)
      click_link 'Next question'
      wait_for_ajax
      page.choose("choice-#{choice_7.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Incorrect,"
      expect(page).to have_content topic_exp_bar(student, topic, 70)
      click_link 'Next question'
      wait_for_ajax
      fill_in 'x3', with: '33'
      fill_in 'x4', with: '44'
      click_button 'Submit Answer'
      wait_for_ajax
      expect(page).to have_content "Correct!"
      expect(page).to have_content topic_exp_bar(student, topic, 140)
    end
  end
end
