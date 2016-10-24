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

  context "display answered questions for a given time period" do
    before(:each) do
      time = Time.now - (6*24*60*60)
      time_2 = Time.now - (10*24*60*60)
      create_answered_question(student, question_4, true, time)
      create_answered_question(student, question_5, true, time_2)
      sign_in admin
    end

    scenario "default show questions for the past week" do
      visit answered_questions_path
      fill_in 'Email', with: student.email
      click_button 'Get Answered Questions'
      expect(page).to have_content 'question text 4'
      expect(page).not_to have_content 'question text 5'
    end

    scenario "show questions for the week before last week" do
      from_date = (Time.now - (14*24*60*60)).strftime('%d/%m/%Y')
      to_date = (Time.now - (7*24*60*60)).strftime('%d/%m/%Y')
      visit answered_questions_path
      fill_in 'Email', with: student.email
      fill_in 'from_date', with: from_date
      fill_in 'to_date', with: to_date
      click_button 'Get Answered Questions'
      expect(page).to have_content 'question text 5'
      expect(page).not_to have_content 'question text 4'
    end

    scenario "display default if date fields are nil" do
      visit answered_questions_path
      fill_in 'Email', with: student.email
      fill_in 'from_date', with: ""
      fill_in 'to_date', with: ""
      click_button 'Get Answered Questions'
      expect(page).to have_content 'question text 4'
      expect(page).not_to have_content 'question text 5'
    end
  end
end
