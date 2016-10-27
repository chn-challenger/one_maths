feature 'Student Management' do
  let!(:course)   { create_course  }
  let!(:unit)     { create_unit course }
  let!(:unit_2)   { create_unit_2 course }
  let!(:topic)    { create_topic unit }
  let!(:topic_2)  { create_topic_2 unit_2 }
  let!(:lesson)   { create_lesson topic }
  let!(:lesson_2) { create_lesson_2 topic_2 }
  let!(:admin)    { create_admin   }
  let!(:student)  { create_student }
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
  let!(:answer_1){create_answer(question_4,1)}
  let!(:answer_2){create_answer(question_4,2)}
  let!(:question_5){create_question(5)}
  let!(:answer_3){create_answer(question_5,3)}

  let!(:question_16){create_question_with_order(16,"c1")}
  let!(:answer_16){create_answer(question_16,16)}
  let!(:question_15){create_question_with_order(15,"c1")}
  let!(:answer_15){create_answer(question_15,15)}
  let!(:question_12){create_question_with_order(12,"d1")}
  let!(:answer_12){create_answer(question_12,12)}
  let!(:question_11){create_question_with_order(11,"d1")}
  let!(:answer_11){create_answer(question_11,11)}
  let!(:question_14){create_question_with_order(14,"b1")}
  let!(:answer_14){create_answer(question_14,14)}
  let!(:question_13){create_question_with_order(13,"b1")}
  let!(:answer_13){create_answer(question_13,13)}

  let!(:question_21){create_question_with_order(21,"a1")}
  let!(:answer_21){create_answer_with_two_values(question_21,21,1.33322,2)}
  let!(:question_22){create_question_with_order(22,"b1")}
  let!(:answer_22){create_answer_with_two_values(question_22,22,-1.23,-2)}

  let!(:question_23){create_question_with_order(23,"b1")}
  let!(:answer_23){create_answers(question_23,[['x=','+5,-8'],['y=','6'],
    ['z=','7'],['w=','8']])}
  let!(:question_24){create_question_with_order(24,"b1")}
  let!(:answer_24){create_answers(question_24,[['a=','+5,-8'],['b=','6'],
    ['c=','7']])}
  let!(:question_25){create_question_with_order(25,"b1")}
  let!(:answer_25){create_answers(question_25,[['a=','+5,-8,7.1,6.21']])}
  let!(:question_26){create_question_with_order(26,"b1")}
  let!(:answer_26){create_answers(question_26,[['a=','+5,-8,6.21'],['b=','7'],['c=','4']])}

  context "#student_manager" do
    before(:each) do
      lesson.questions.push(question_3, question_4)
      lesson_2.questions << question_5
      time = Time.now - (6*24*60*60)
      time_2 = Time.now - (10*24*60*60)
      create_answered_question_manager(student, question_3, lesson)
      create_answered_question_manager(student, question_4, lesson)
      create_answered_question_manager(student, question_5, lesson_2)
      StudentLessonExp.create(user_id: student.id, lesson_id: lesson.id, exp: 100, streak_mtp: 1)
      StudentLessonExp.create(user_id: student.id, lesson_id: lesson_2.id, exp: 200, streak_mtp: 2)
      StudentTopicExp.create(user_id: student.id, topic_id: topic.id, exp: 1000, streak_mtp: 1)
      StudentTopicExp.create(user_id: student.id, topic_id: topic_2.id, exp: 2000, streak_mtp: 2)
      sign_in admin
      visit student_manager_path
      fill_in 'Email', with: student.email
      click_button 'Get Student Questions'
    end

    scenario "Where student has answered questions display Units, Topics and Lessons" do
      expect(current_path).to eq '/student_manager'
      expect(page).to have_content 'Core 1'
      expect(page).to have_content 'Core 2'
      expect(page).to have_content 'Indices'
      expect(page).to have_content 'Sequence'
      expect(page).to have_content 'Test lesson'
      expect(page).to have_content 'Test lesson 2'
    end

    scenario "Admin can edit exp on Topic" do
      expect(current_path).to eq '/student_manager'
      expect(page).to have_content 'Exp: 1000'
      expect(page).not_to have_content 'Exp: 500'
      click_button "topic-#{topic.id}"
      fill_in "expTopic-#{topic.id}", with: 500
      click_button "expSubmitTopic-#{topic.id}"
      expect(page).to have_content 'Exp: 500'
    end

    scenario "Admin can edit exp on Lesson" do
      expect(page).to have_content 'Exp: 100'
      expect(page).not_to have_content 'Exp: 125'
      click_button "lesson-#{lesson.id}"
      fill_in "expLesson-#{lesson.id}", with: 125
      click_button "expSubmitLesson-#{lesson.id}"
      expect(current_path).to eq '/student_manager'
      expect(page).to have_content 'Exp: 125'
    end
  end

  context "#edit_student_questions" do
    before(:each) do
      lesson.questions.push(question_3, question_4)
      lesson_2.questions << question_5
      time = Time.now - (6*24*60*60)
      time_2 = Time.now - (10*24*60*60)
      create_answered_question_manager(student, question_3, lesson)
      create_answered_question_manager(student, question_4, lesson)
      create_answered_question_manager(student, question_5, lesson_2)
      StudentLessonExp.create(user_id: student.id, lesson_id: lesson.id, exp: 100, streak_mtp: 1)
      StudentLessonExp.create(user_id: student.id, lesson_id: lesson_2.id, exp: 200, streak_mtp: 2)
      StudentTopicExp.create(user_id: student.id, topic_id: topic.id, exp: 1000, streak_mtp: 1)
      StudentTopicExp.create(user_id: student.id, topic_id: topic_2.id, exp: 2000, streak_mtp: 2)
      sign_in admin
      visit student_manager_path
      fill_in 'Email', with: student.email
      click_button 'Get Student Questions'
    end

    scenario "Admin can view student answered questions for a specific lesson" do
      click_link "edit-answered-question-lesson-#{lesson.id}"
      expect(page).to have_content lesson.name
      expect(page).to have_content question_3.question_text
      expect(page).not_to have_content question_5.question_text
      expect(page).to have_content 'Answered correctly'
    end

    scenario "Admin can delete student answered questions" do
      click_link "edit-answered-question-lesson-#{lesson.id}"
      check "question_#{question_3.id}"
      expect(page).to have_content question_3.question_text
      expect(page).to have_content question_4.question_text
      click_button 'Delete selected'
      expect(page).to have_content question_4.question_text
      expect(page).not_to have_content question_3.question_text
    end
  end


end
