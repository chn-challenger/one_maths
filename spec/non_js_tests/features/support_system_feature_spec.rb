require 'support_system_helpers'

feature 'Support System' do
  let!(:course) { create_course }
  let!(:unit)   { create_unit course }
  let!(:topic)  { create_topic unit }
  let!(:lesson) { create_lesson topic }
  let!(:admin)  { create_admin }
  let!(:student) { create_student }
  let!(:student_2) { create_student_2 }
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
  let!(:answer_6) { create_answers(question_6, [["a=",'x=>5'], ['b=','100=z'],['c=','-19=>x']], 'inequality') }
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
  let!(:ticket) { create_support_ticket(question_24, student, 'Support comment 1') }
  let!(:ticket_2) { create_support_ticket(question_21, student_2, 'Support comment 2') }

  context 'report submission' do
    before(:each) do
      lesson.questions = [question_23]
      lesson.save
    end

    scenario 'student submits a report on a question' do
      sign_in student
      visit "/units/#{unit.id}"
      expect(page).to have_link "bug-report-q#{question_23.id}"
      click_link "bug-report-q#{question_23.id}"
      expect(current_path).to eq '/tickets/new'
      select 'Question Error', from: 'tag_Category'
      fill_in 'Description', with: 'The is an error with the working out of the solution.'
      expect(Ticket.all.count).to eq 2
      click_button 'Create Ticket'
      expect(current_path).to eq "/units/#{unit.id}"
      expect(Ticket.all.count).to eq 3
    end

  end

  context 'report review' do
    scenario 'admin can view all submitted reports' do
      sign_in admin
      click_link 'Tickets'
      expect(page).to have_content 'Question Error', count: 2
      expect(page).to have_content 'Support comment 1...'
      expect(page).to have_content 'Support comment 2...'
      expect(page).to have_link "View #{ticket.id}"
      expect(page).to have_link "View #{ticket_2.id}"
      expect(page).to have_link "Delete #{ticket.id}"
      expect(page).to have_link "Delete #{ticket_2.id}"
    end

    scenario 'admin can view a submitted report' do
      lesson.questions = [question_24]
      lesson.save
      sign_in admin
      click_link 'Tickets'
      click_link "View #{ticket.id}"
      expect(page).to have_content "Question #{question_24.id}"
      expect(page).to have_content question_24.question_text
      expect(page).to have_content question_24.solution
      expect(page).to have_content lesson.name
      expect(page).to have_content 'No answer has been recorded'
      expect(page).to have_link 'Edit question'
      expect(page).to have_link 'Edit answer'
    end

    scenario 'student can view all of his open tickets' do
      sign_in student
      click_link 'Tickets'
      expect(page).to have_content 'Question Error'
      expect(page).to have_content 'Support comment 1...'
      expect(page).to have_link "View #{ticket.id}"
      expect(page).not_to have_link "View #{ticket_2.id}"
      expect(page).not_to have_link "Delete #{ticket.id}"
    end

    scenario 'can\'t view tickets unless signed in' do
      visit "/tickets"
      expect(current_path).to eq new_user_session_path
      visit "/tickets/#{ticket_2.id}"
      expect(current_path).to eq new_user_session_path
    end

    scenario 'student cannot view other peoples tickets' do
      sign_in student
      visit "/tickets/#{ticket_2.id}"
      expect(current_path).to eq root_path
      expect(page).to have_content 'You are not authorized'
    end
  end

  context 'deleting a ticket' do
    scenario 'admin can delete a ticket' do
      sign_in admin
      click_link 'Tickets'
      expect(page).to have_link "View #{ticket_2.id}"
      click_link "Delete #{ticket_2.id}"
      expect(page).not_to have_link "View #{ticket_2.id}"
    end

    scenario 'normal user cannot view tickets delete link' do
      sign_in student
      click_link 'Tickets'
      expect(page).not_to have_link "Delete #{ticket.id}"
      expect(page).to have_link "View #{ticket.id}"
    end
  end

end
