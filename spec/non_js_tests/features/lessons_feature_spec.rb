feature 'lessons' do
  let!(:super_admin){create_super_admin}
  let!(:course) { create_course  }
  let!(:unit)   { create_unit course }
  let!(:topic)  { create_topic unit }
  let!(:lesson) { create_lesson topic, "", 'Published' }
  let!(:lesson_2) { create_lesson topic, 2, 'Published' }
  let!(:lesson_3) { create_lesson topic, 3, 'Test'}
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
  let!(:question_6) { create_question(6) }
  let!(:answer_6) { create_answers(question_6, [["a=",'10=>x=>5'], ['b=','100=z or z=2/3'],['c=','-19=>x']], 'inequality') }
  let!(:question_7) { create_question(7) }
  let!(:answer_7) { create_answers(question_7, [["a=",'(5/2, 2.34)'], ['b=','(-3, -2.42)'], ['c=','(-9/11, 2)']], 'coordinates') }
  let!(:question_8) { create_question(8) }
  let!(:answer_8) { create_answers(question_8, [['a=','InfLection PoINT'], ['b=','maximum']], 'words') }
  let!(:question_9) { create_question_with_order(9,'f1') }
  let!(:question_10) { create_question_with_order(9,'g1') }

  context 'update pass experience' do
    scenario 'adding 3 questions same order to lesson updates pass exp to 100' do
      sign_in admin
      visit "/units/#{ unit.id }"
      find(:xpath, "//a[@href='/lessons/#{lesson.id}/new_question']").click
      expect(lesson.pass_experience).to eq 0
      expect(lesson.questions.count).to eq 0
      check "question_#{question_1.id}"
      check "question_#{question_2.id}"
      check "question_#{question_3.id}"
      click_button "Update Lesson"
      expect(lesson.questions.count).to eq 3
      expect(page).to have_content '0 / 100'
    end

    scenario 'adding 3 questions diff order to lesson updates pass exp to 225' do
      sign_in admin
      visit "/units/#{ unit.id }"
      find(:xpath, "//a[@href='/lessons/#{lesson.id}/new_question']").click
      expect(lesson.pass_experience).to eq 0
      expect(lesson.questions.count).to eq 0
      check "question_#{question_1.id}"
      check "question_#{question_9.id}"
      check "question_#{question_10.id}"
      click_button "Update Lesson"
      expect(lesson.questions.count).to eq 3
      expect(page).to have_content '0 / 375'
    end

    scenario 'updating question updates lesson pass_experience' do
      lesson.questions = [question_1, question_3]
      lesson.save
      sign_in admin
      visit "/units/#{ unit.id }"
      expect(page).to have_content '0 / 100'
      visit "/questions/#{question_3.id}/edit"
      fill_in 'Order', with: 'z2'
      click_button 'Save Progress'
      visit "/units/#{ unit.id }"
      expect(page).to have_content '0 / 225'
    end
  end

  context 'current_questions for lessons' do
    before(:each) do
      lesson.questions = [question_1,question_2,question_3]
      lesson.save
      # sign_in admin
      # visit "/units/#{ unit.id }"
      # find(:xpath, "//a[@href='/lessons/#{lesson.id}/new_question']").click
      # check "question_#{question_1.id}"
      # check "question_#{question_2.id}"
      # check "question_#{question_3.id}"
      # click_button "Update Lesson"
      # sign_out_ajax
    end

    scenario 'a current question is assigned when a student first visit a lesson', js: true do
      sign_in student
      visit "/units/#{ unit.id }"
      find("#chapter-collapsable-#{topic.id}").trigger('click')
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      wait_for_ajax
      sleep 5
      expect(student.has_current_question?(lesson)).to eq true
    end

    scenario 'once a current question is set it does not change', js: true do
      sign_in admin
      visit "/units/#{ unit.id }"
      find(:xpath, "//a[@href='/lessons/#{lesson.id}/new_question']").click
      check "question_#{question_1.id}"
      check "question_#{question_2.id}"
      check "question_#{question_3.id}"
      click_button "Update Lesson"
      sign_out_ajax

      sign_in student
      visit "/units/#{ unit.id }"
      srand(102) # question 1
      sleep 5
      expect(student.has_current_question?(lesson)).to eq false
      visit "/units/#{ unit.id }"
      find("#chapter-collapsable-#{topic.id}").trigger('click')
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      wait_for_ajax
      expect(page).to have_content question_1.question_text
      expect(student.has_current_question?(lesson)).to eq true
      expect(student.fetch_current_question(lesson)).to eq question_1
      sign_out_ajax

      sign_in student
      visit "/units/#{ unit.id }"
      find("#chapter-collapsable-#{topic.id}").trigger('click')
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      wait_for_ajax
      expect(student.fetch_current_question(lesson)).to eq question_1
      sign_out_ajax

      sign_in student
      visit "/units/#{ unit.id }"
      find("#chapter-collapsable-#{topic.id}").trigger('click')
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      wait_for_ajax
      expect(student.fetch_current_question(lesson)).to eq question_1
      sign_out_ajax

      sign_in student
      visit "/units/#{ unit.id }"
      find("#chapter-collapsable-#{topic.id}").trigger('click')
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      wait_for_ajax
      expect(student.fetch_current_question(lesson)).to eq question_1
    end

    scenario 'a once a different current question is set it does not change', js: true do
      lesson.questions << [question_1, question_2, question_3]
      sign_in student
      srand(101)
      expect(student.has_current_question?(lesson)).to eq false
      visit "/units/#{ unit.id }"
      find("#chapter-collapsable-#{topic.id}").trigger('click')
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      wait_for_ajax
      expect(page).to have_content question_2.question_text
      expect(student.has_current_question?(lesson)).to eq true
      expect(student.fetch_current_question(lesson)).to eq question_2
      sign_out_ajax
      sign_in student
      visit "/units/#{ unit.id }"
      find("#chapter-collapsable-#{topic.id}").trigger('click')
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      wait_for_ajax
      sleep 5
      expect(student.fetch_current_question(lesson)).to eq question_2
      sign_out_ajax
      sign_in student
      visit "/units/#{ unit.id }"
      find("#chapter-collapsable-#{topic.id}").trigger('click')
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      wait_for_ajax
      sleep 5
      expect(student.fetch_current_question(lesson)).to eq question_2
      sign_out_ajax
      sign_in student
      visit "/units/#{ unit.id }"
      find("#chapter-collapsable-#{topic.id}").trigger('click')
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      wait_for_ajax
      sleep 5
      expect(student.fetch_current_question(lesson)).to eq question_2
    end
  end

  context 'submitting a question' do
    scenario 'once submitted the current question for the lesson is deleted', js: true do
      lesson.questions << [question_1, question_2, question_3]
      lesson.save
      sign_in student
      srand(101)
      expect(student.has_current_question?(lesson)).to eq false
      visit "/units/#{ unit.id }"
      find("#chapter-collapsable-#{topic.id}").trigger('click')
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      wait_for_ajax
      expect(page).to have_content question_2.question_text
      expect(student.has_current_question?(lesson)).to eq true
      expect(student.fetch_current_question(lesson)).to eq question_2
      sign_out_ajax
      sign_in student
      visit "/units/#{ unit.id }"
      find("#chapter-collapsable-#{topic.id}").trigger('click')
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      wait_for_ajax
      sleep 5
      expect(student.has_current_question?(lesson)).to eq true
      expect(student.fetch_current_question(lesson)).to eq question_2
      expect(AnsweredQuestion.all.length).to eq 0
      page.choose("choice-#{choice_4.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      sleep 5
      expect(AnsweredQuestion.all.length).to eq 1
      expect(student.has_current_question?(lesson)).to eq false
      srand(101) #3
      click_link 'Next question'
      wait_for_ajax
      sleep 5
      expect(student.has_current_question?(lesson)).to eq true
      expect(student.fetch_current_question(lesson)).to eq question_3
      page.choose("choice-#{choice_6.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(AnsweredQuestion.all.length).to eq 2
    end

    scenario 'answered questions no longer appear again eg 1', js: true do
      # sign_in admin
      # visit "/units/#{ unit.id }"
      # find(:xpath, "//a[@href='/lessons/#{lesson.id}/new_question']").click
      # check "question_#{question_1.id}"
      # check "question_#{question_2.id}"
      # check "question_#{question_3.id}"
      # click_button "Update Lesson"
      # visit('/')
      # sign_out_ajax
      # lesson.questions = [question_1,question_2,question_3]
      # lesson.save
      lesson.questions = [question_1,question_2,question_3]
      lesson.save
      sign_in student
      srand(103)
      visit "/units/#{ unit.id }"
      find("#chapter-collapsable-#{topic.id}").trigger('click')
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      wait_for_ajax
      expect(page).to have_content "question text 2"
      page.choose("choice-#{choice_4.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      click_link 'Next question'
      wait_for_ajax
      expect(page).not_to have_content "question text 2"
      expect(page).to have_content "question text 3"
    end

    scenario 'answered questions no longer appear again eg 2', js: true do
      # sign_in admin
      # visit "/units/#{ unit.id }"
      # find(:xpath, "//a[@href='/lessons/#{lesson.id}/new_question']").click
      # check "question_#{question_1.id}"
      # check "question_#{question_2.id}"
      # check "question_#{question_3.id}"
      # click_button "Update Lesson"
      # visit('/')
      # sign_out_ajax
      lesson.questions = [question_1,question_2,question_3]
      lesson.save
      sign_in student
      srand(101)
      visit "/units/#{ unit.id }"
      find("#chapter-collapsable-#{topic.id}").trigger('click')
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      wait_for_ajax
      page.choose("choice-#{choice_4.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      srand(102) #1
      click_link 'Next question'
      expect(page).to have_content "question text 1"
    end
  end

  context '#next_question' do
    scenario 'incorrect questions get reset upon completing all available questions', js: true do
      lesson.questions << [question_1, question_2]
      lesson.save
      create_ans_q(student, question_1, 0.0, 0, lesson)
      sign_in student
      visit "/units/#{unit.id}"
      find("#chapter-collapsable-#{topic.id}").trigger('click')
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      wait_for_ajax
      expect(page).to have_content 'question text 2'
      page.choose("choice-#{choice_4.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      click_link 'Next question'
      wait_for_ajax
      expect(page).to have_content 'question text 1'
    end

    scenario 'partially correct questions do not get reset', js: true do
      lesson.questions << [question_1, question_2]
      lesson.save
      create_ans_q(student, question_1, 0.5, 0, lesson)
      sign_in student
      visit "/units/#{unit.id}"
      find("#chapter-collapsable-#{topic.id}").trigger('click')
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      # wait_for_ajax
      expect(page).to have_content 'question text 2'
      page.choose("choice-#{choice_4.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      click_link 'Next question'
      message = 'You have attempted all the questions available for this lesson, contact us to ask for more!'
      expect(page).to have_content message
    end
  end


  context 'Gaining experience for a lesson' do
    scenario 'gaining experience for a lesson for first time', js: true do
      lesson.questions = [question_1,question_2,question_3]
      lesson.save
      srand(103)
      sign_in student
      visit "/units/#{ unit.id }"
      find("#chapter-collapsable-#{topic.id}").trigger('click')
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      wait_for_ajax
      page.choose("choice-#{choice_4.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(StudentLessonExp.current_exp(student,lesson)).to eq 100
      expect(page).to have_content '100 / 100'
    end

    scenario 'gaining experience for a lesson again', js: true do
      lesson.questions = [question_1,question_2,question_3]
      lesson.save
      srand(103)
      sign_in student
      visit "/units/#{ unit.id }"
      find("#chapter-collapsable-#{topic.id}").trigger('click')
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      wait_for_ajax
      page.choose("choice-#{choice_4.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      click_link 'Next question'
      wait_for_ajax
      page.choose("choice-#{choice_6.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(StudentLessonExp.current_exp(student,lesson)).to eq 100
      expect(page).to have_content topic_exp_bar(student, topic, 0)
      expect(page).to have_content '100 / 100'
    end

    scenario 'not gaining experience for a lesson when answering incorrectly', js: true do
      lesson.questions = [question_1,question_2,question_3]
      lesson.save
      srand(102)
      sign_in student
      visit "/units/#{ unit.id }"
      find("#chapter-collapsable-#{topic.id}").trigger('click')
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      wait_for_ajax
      page.choose("choice-#{choice_2.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      click_link 'Next question'
      wait_for_ajax
      page.choose("choice-#{choice_4.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      click_link 'Next question'
      wait_for_ajax
      page.choose("choice-#{choice_5.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(StudentLessonExp.last.exp).to eq 225
    end
  end

  context 'adding a lesson' do
    scenario 'an admin can add a lessons' do
      sign_in admin
      visit "/units/#{ unit.id }"
      click_link 'Add a lesson to chapter'
      fill_in 'Name', with: 'New lesson'
      fill_in 'Description', with: 'Lesson desc'
      fill_in 'Pass experience', with: 1999
      fill_in 'Sort order', with: 2
      click_button 'Create Lesson'
      expect(page).to have_content 'New lesson'
      expect(page).to have_content '0 / 0'
      expect(current_path).to eq "/units/#{ unit.id }"
    end

    scenario 'when lesson added default status is test' do
      sign_in admin
      visit "/units/#{ unit.id }"
      click_link 'Add a lesson to chapter'
      fill_in 'Name', with: 'New lesson'
      fill_in 'Description', with: 'Lesson desc'
      fill_in 'Pass experience', with: 1999
      fill_in 'Sort order', with: 2
      click_button 'Create Lesson'
      expect(page).to have_content 'Test'
      expect(page).to have_link "lesson-status-#{lesson.id}"
      expect(current_path).to eq "/units/#{ unit.id }"
    end

    scenario 'lesson can be added with status "Published"' do
      sign_in admin
      visit "/units/#{ unit.id }"
      click_link 'Add a lesson to chapter'
      fill_in 'Name', with: 'New lesson'
      fill_in 'Description', with: 'Lesson desc'
      fill_in 'Pass experience', with: 1999
      select 'Published', from: 'Status'
      fill_in 'Sort order', with: 2
      click_button 'Create Lesson'
      expect(page).to have_content 'Published', count: 3
      expect(page).to have_link "lesson-status-#{Lesson.last.id}"
      expect(current_path).to eq "/units/#{ unit.id }"
    end

    scenario 'cannot add a lesson if not signed in' do
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Add a lesson to chapter'
    end

    scenario 'cannot visit the add lesson page unless signed in' do
      visit "/topics/#{ topic.id }/lessons/new"
      expect(current_path).to eq new_user_session_path
    end

    scenario 'cannot add a lesson if signed in as a student' do
      sign_in student
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Add a lesson to chapter'
    end

    scenario 'cannot visit the add lesson page if signed in as a student' do
      sign_in student
      visit "/topics/#{ topic.id }/lessons/new"
      expect(current_path).to eq "/units/#{ unit.id }"
      expect(page).to have_content 'You do not have permission to add a lesson'
    end
  end

  context 'updating lessons' do
    scenario 'an admin can edit a lesson' do
      sign_in admin
      visit "/units/#{ unit.id }"
      edit_links = all('a', :text => 'Edit lesson')
      edit_links[0].click
      fill_in 'Name', with: 'New lesson one'
      fill_in 'Description', with: 'New lesson desc'
      fill_in 'Pass experience', with: 1000
      fill_in 'Sort order', with: 2
      select 'Test', from: 'Status'
      click_button 'Update Lesson'
      expect(page).to have_content 'New lesson one'
      expect(page).to have_content 'Test', count: 3
      expect(current_path).to eq "/units/#{ unit.id }"
    end

    scenario 'an admin changes lesson status from unit page' do
      sign_in admin
      visit "/units/#{ unit.id }"
      expect(page).to have_content 'Published', count: 2
      click_link "lesson-status-#{lesson.id}"
      expect(page).to have_content 'Test', count: 3
      expect(page).to have_content 'Published', count: 1
    end

    scenario 'when not signed in cannot see edit link' do
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Edit lesson'
    end

    scenario 'when not signed in cannot visit edit page' do
      visit "/lessons/#{ lesson.id }/edit"
      expect(current_path).to eq new_user_session_path
    end

    scenario 'a student cannot see edit link' do
      sign_in student
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Edit lesson'
      expect(page).not_to have_link "lesson-status-#{lesson.id}"
    end

    scenario 'a student cannot visit edit page' do
      sign_in student
      visit "/lessons/#{ lesson.id }/edit"
      expect(page).to have_content 'You do not have permission to edit a lesson'
      expect(current_path).to eq "/units/#{ unit.id }"
    end
  end

  context 'student viewing a question' do
    before(:each) do
      sign_in student
      visit "/units/#{ unit.id }"
    end

    scenario 'cannot view "Test" lessons' do
      expect(page).not_to have_content 'Lesson 3'
      expect(page).not_to have_content 'Status: Test'
      expect(page).not_to have_content 'Status: Published'
      expect(page).to have_content 'Lesson 2'
      expect(page).to have_content 'Lesson'
    end
  end

  context 'deleting lessons' do
    scenario 'a super admin can delete a course' do
      sign_in super_admin
      visit "/units/#{ unit.id }"
      find("a[@href='/lessons/#{lesson.id}']").click
      # find_link('Delete lesson')[:href]
      expect(page).not_to have_link "a[@href='/lessons/#{lesson.id}']"
      expect(page).to have_content 'Lesson deleted successfully'
      expect(current_path).to eq "/units/#{ unit.id }"
    end

    scenario 'an admin do not see delete link' do
      sign_in admin
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Delete lesson'
    end

    scenario 'an admin can send delete request' do
      sign_in admin
      page.driver.submit :delete, "/lessons/#{ lesson.id }",{}
      expect(page).to have_content 'Lesson deleted successfully'
      expect(current_path).to eq "/units/#{ unit.id }"
    end

    scenario 'when not signed in cannot see delete link' do
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Delete lesson'
    end

    scenario 'when not signed in cannot send delete request' do
      page.driver.submit :delete, "/lessons/#{ lesson.id }",{}
      expect(current_path).to eq new_user_session_path
    end

    scenario 'a student cannot see delete link' do
      sign_in student
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Delete lesson'
    end

    scenario 'a student cannot send a delete request' do
      sign_in student
      page.driver.submit :delete, "/lessons/#{ lesson.id }",{}
      expect(page).to have_content 'You do not have permission to delete a lesson'
      expect(current_path).to eq "/units/#{ unit.id }"
    end
  end

  context 'adding questions to lesson' do
    scenario 'an admin can add questions to a lesson' do
      sign_in admin
      visit "/units/#{ unit.id }"
      expect(lesson.questions.count).to eq 0
      find("a[@href='/lessons/#{lesson.id}/new_question']").click
      check "question_#{question_1.id}"
      check "question_#{question_3.id}"
      click_button "Update Lesson"
      expect(lesson.questions.count).to eq 2
    end

    scenario 'an admin can change the list of questions on a lesson' do
      sign_in admin
      visit "/units/#{ unit.id }"
      expect(lesson.questions.count).to eq 0
      find("a[@href='/lessons/#{lesson.id}/new_question']").click
      check "question_#{question_1.id}"
      check "question_#{question_3.id}"
      click_button "Update Lesson"
      expect(lesson.questions.count).to eq 2
      find("a[@href='/lessons/#{lesson.id}/new_question']").click
      uncheck "question_#{question_1.id}"
      uncheck "question_#{question_3.id}"
      check "question_#{question_2.id}"
      click_button "Update Lesson"
      expect(lesson.questions.count).to eq 1
    end

    scenario 'an admin can not see already added questions' do
      sign_in admin
      visit "/units/#{ unit.id }"
      find("a[@href='/lessons/#{lesson.id}/new_question']").click
      check "question_#{question_1.id}"
      check "question_#{question_3.id}"
      click_button "Update Lesson"
      find("a[@href='/lessons/#{lesson_2.id}/new_question']").click
      expect(page).to have_content "question text 2"
      expect(page).not_to have_content "question text 1"
      expect(page).not_to have_content "question text 3"
    end

    scenario 'when not logged on cannot add questions to a lesson' do
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Add questions to lesson'
      visit "/lessons/#{lesson.id}/new_question"
      expect(current_path).to eq new_user_session_path
    end

    scenario 'when not logged on as a student cannot add questions to a lesson' do
      sign_in student
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Add questions to lesson'
      visit "/lessons/#{lesson.id}/new_question"
      expect(page).to have_content 'You do not have permission to add questions to lesson'
      expect(current_path).to eq "/units/#{ unit.id }"
    end

    scenario 'admin can create a new question from the add question page' do
      sign_in admin
      visit "/questions/new"
      fill_in 'Question text', with: 'Solve $2+x=5$'
      fill_in 'Solution', with: '$x=2$'
      fill_in 'Difficulty level', with: 2
      fill_in 'Experience', with: 100
      click_button 'Create Question'
      expect(page).to have_content 'Solve $2+x=5$'
      expect(page).to have_content '$x=2$'
    end
  end
end
