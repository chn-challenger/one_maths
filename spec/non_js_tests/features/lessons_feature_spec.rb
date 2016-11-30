feature 'lessons' do
  let!(:super_admin){create_super_admin}
  let!(:course) { create_course  }
  let!(:unit)   { create_unit course }
  let!(:topic)  { create_topic unit }
  let!(:lesson) { create_lesson topic }
  let!(:lesson_2) { create_lesson_2 topic}
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

  context 'current_questions for lessons' do
    before(:each) do
      sign_in admin
      visit "/units/#{ unit.id }"
      find("a[@href='/lessons/#{lesson.id}/new_question']").click
      check "question_#{question_1.id}"
      check "question_#{question_2.id}"
      check "question_#{question_3.id}"
      click_button "Update Lesson"
      click_link 'Sign out'
    end

    scenario 'a current question is assigned when a student first visit a lesson' do
      sign_in student
      visit "/units/#{ unit.id }"
      expect(student.has_current_question?(lesson)).to eq true
    end

    scenario 'once a current question is set it does not change' do
      sign_in admin
      visit "/units/#{ unit.id }"
      find("a[@href='/lessons/#{lesson.id}/new_question']").click
      check "question_#{question_1.id}"
      check "question_#{question_2.id}"
      check "question_#{question_3.id}"
      click_button "Update Lesson"
      visit('/')
      click_link 'Sign out'
      sign_in student
      # srand(114) # question 3
      # srand(101) # question 2
      srand(102) # question 1
      expect(student.has_current_question?(lesson)).to eq false
      visit "/units/#{ unit.id }"
      expect(student.has_current_question?(lesson)).to eq true
      expect(student.fetch_current_question(lesson)).to eq question_1
      click_link 'Sign out'
      sign_in student
      visit "/units/#{ unit.id }"
      expect(student.fetch_current_question(lesson)).to eq question_1
      click_link 'Sign out'
      sign_in student
      visit "/units/#{ unit.id }"
      expect(student.fetch_current_question(lesson)).to eq question_1
      click_link 'Sign out'
      sign_in student
      visit "/units/#{ unit.id }"
      expect(student.fetch_current_question(lesson)).to eq question_1
    end

    scenario 'a once a different current question is set it does not change' do
      sign_in admin
      visit "/units/#{ unit.id }"
      find("a[@href='/lessons/#{lesson.id}/new_question']").click
      check "question_#{question_1.id}"
      check "question_#{question_2.id}"
      check "question_#{question_3.id}"
      click_button "Update Lesson"
      visit('/')
      click_link 'Sign out'
      sign_in student
      srand(101)
      expect(student.has_current_question?(lesson)).to eq false
      visit "/units/#{ unit.id }"
      expect(student.has_current_question?(lesson)).to eq true
      expect(student.fetch_current_question(lesson)).to eq question_2
      click_link 'Sign out'
      sign_in student
      visit "/units/#{ unit.id }"
      expect(student.fetch_current_question(lesson)).to eq question_2
      click_link 'Sign out'
      sign_in student
      visit "/units/#{ unit.id }"
      expect(student.fetch_current_question(lesson)).to eq question_2
      click_link 'Sign out'
      sign_in student
      visit "/units/#{ unit.id }"
      expect(student.fetch_current_question(lesson)).to eq question_2
    end
  end

  context 'submitting a question' do
    scenario 'once submitted the current question for the lesson is deleted' do
      sign_in admin
      visit "/units/#{ unit.id }"
      find("a[@href='/lessons/#{lesson.id}/new_question']").click
      check "question_#{question_1.id}"
      check "question_#{question_2.id}"
      check "question_#{question_3.id}"
      click_button "Update Lesson"
      visit('/')
      click_link 'Sign out'
      sign_in student
      srand(101)
      expect(student.has_current_question?(lesson)).to eq false
      visit "/units/#{ unit.id }"
      expect(student.has_current_question?(lesson)).to eq true
      expect(student.fetch_current_question(lesson)).to eq question_2
      click_link 'Sign out'
      sign_in student
      visit "/units/#{ unit.id }"
      expect(student.has_current_question?(lesson)).to eq true
      expect(student.fetch_current_question(lesson)).to eq question_2
      expect(AnsweredQuestion.all.length).to eq 0
      page.choose("choice-#{choice_4.id}")
      click_button 'Submit Answer'
      expect(AnsweredQuestion.all.length).to eq 1
      expect(student.has_current_question?(lesson)).to eq false
      srand(101) #3
      visit "/units/#{ unit.id }"
      expect(student.has_current_question?(lesson)).to eq true
      expect(student.fetch_current_question(lesson)).to eq question_3
      page.choose("choice-#{choice_6.id}")
      click_button 'Submit Answer'
      expect(AnsweredQuestion.all.length).to eq 2
    end

    scenario 'answered questions no longer appear again eg 1' do
      sign_in admin
      visit "/units/#{ unit.id }"
      find("a[@href='/lessons/#{lesson.id}/new_question']").click
      check "question_#{question_1.id}"
      check "question_#{question_2.id}"
      check "question_#{question_3.id}"
      click_button "Update Lesson"
      visit('/')
      click_link 'Sign out'
      sign_in student
      srand(103)
      visit "/units/#{ unit.id }"
      expect(page).to have_content "question text 2"
      page.choose("choice-#{choice_4.id}")
      click_button 'Submit Answer'
      visit "/units/#{ unit.id }"
      expect(page).not_to have_content "question text 2"
      expect(page).to have_content "question text 3"
    end

    scenario 'answered questions no longer appear again eg 2' do
      sign_in admin
      visit "/units/#{ unit.id }"
      question_links = all('a', :text => 'Add questions to lesson')
      question_links[0].click
      check "question_#{question_1.id}"
      check "question_#{question_2.id}"
      check "question_#{question_3.id}"
      click_button "Update Lesson"
      visit('/')
      click_link 'Sign out'
      sign_in student
      srand(101)
      visit "/units/#{ unit.id }"
      page.choose("choice-#{choice_4.id}")
      click_button 'Submit Answer'
      srand(102) #1
      visit "/units/#{ unit.id }"
      expect(page).to have_content "question text 1"
    end
  end

  context 'Gaining experience for a lesson' do
    scenario 'gaining experience for a lesson for first time' do
      lesson.questions = [question_1,question_2,question_3]
      lesson.save
      sign_in student
      visit "/units/#{ unit.id }"
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
      expect(StudentLessonExp.current_exp(student,lesson)).to eq 100
      visit "/units/#{ unit.id }"
      expect(page).to have_content '100/1000'
    end

    scenario 'gaining experience for a lesson again' do
      lesson.questions = [question_1,question_2,question_3]
      lesson.save
      sign_in student
      visit "/units/#{ unit.id }"
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
      visit "/units/#{ unit.id }"
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
      expect(StudentLessonExp.current_exp(student,lesson)).to eq 225
      visit "/units/#{ unit.id }"
      expect(page).to have_content '225/1000'
    end

    scenario 'not gaining experience for a lesson when answering incorrectly' do
      lesson.questions = [question_1,question_2,question_3]
      lesson.save
      sign_in student
      visit "/units/#{ unit.id }"
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
      visit "/units/#{ unit.id }"
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
      visit "/units/#{ unit.id }"
      if page.has_content?("question text 1")
        page.choose("choice-#{choice_1.id}")
      end
      if page.has_content?("question text 2")
        page.choose("choice-#{choice_3.id}")
      end
      if page.has_content?("question text 3")
        page.choose("choice-#{choice_5.id}")
      end
      click_button 'Submit Answer'
      expect(StudentLessonExp.current_exp(student,lesson)).to eq 225
    end

    scenario 'correctly showing maxed out exp' do
      student_lesson_exp = create_student_lesson_exp(student,lesson,1500)
      expect(StudentLessonExp.current_exp(student,lesson)).to eq 1000
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
      expect(page).to have_content '0/1999'
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
      click_button 'Update Lesson'
      expect(page).to have_content 'New lesson one'
      expect(current_path).to eq "/units/#{ unit.id }"
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
    end

    scenario 'a student cannot visit edit page' do
      sign_in student
      visit "/lessons/#{ lesson.id }/edit"
      expect(page).to have_content 'You do not have permission to edit a lesson'
      expect(current_path).to eq "/units/#{ unit.id }"
    end
  end

  context 'editing questions' do
    scenario 'it redirects to the same page' do
      sign_in admin
      visit "/units/#{ unit.id }"
      question_links = all('a', :text => 'Add questions to lesson')
      question_links[0].click
      check "question_#{question_1.id}"
      click_button "Update Lesson"
      click_link 'Edit question'
      fill_in 'Question text', with: 'Solve $2+x=5$'
      fill_in 'Solution', with: '$x=2$'
      fill_in 'Difficulty level', with: 2
      fill_in 'Experience', with: 100
      click_button 'Save Progress'
      expect(current_path).to eq "/questions/#{ question_1.id }/edit"
      expect(page).to have_content 'Solve $2+x=5$'
      expect(page).to have_content '$x=2$'
    end
  end

  context 'deleting lessons' do
    scenario 'a super admin can delete a course' do
      sign_in super_admin
      visit "/units/#{ unit.id }"
      find("a[@href='/lessons/#{lesson.id}']").click
      expect(find_link('Delete lesson')[:href]).not_to eq "/lessons/#{lesson.id}"
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
      question_links = all('a', :text => 'Add questions to lesson')
      question_links[0].click
      check "question_#{question_1.id}"
      check "question_#{question_3.id}"
      click_button "Update Lesson"
      expect(page).to have_content 'question text 1'
      expect(page).to have_content 'solution 1'
      expect(page).to have_content 'Possible solution 1'
      expect(page).to have_content 'Possible solution 2'
      expect(page).to have_content 'question text 3'
      expect(page).to have_content 'solution 3'
      expect(page).to have_content 'Possible solution 5'
      expect(page).to have_content 'Possible solution 6'
      expect(page).not_to have_content 'Possible solution 3'
    end

    scenario 'an admin can change the list of questions on a lesson' do
      sign_in admin
      visit "/units/#{ unit.id }"
      question_links = all('a', :text => 'Add questions to lesson')
      question_links[0].click
      check "question_#{question_1.id}"
      check "question_#{question_3.id}"
      click_button "Update Lesson"
      question_links = all('a', :text => 'Add questions to lesson')
      question_links[0].click
      uncheck "question_#{question_1.id}"
      uncheck "question_#{question_3.id}"
      check "question_#{question_2.id}"
      click_button "Update Lesson"
      expect(page).to have_content 'question text 2'
      expect(page).to have_content 'solution 2'
      expect(page).to have_content 'Possible solution 3'
      expect(page).to have_content 'Possible solution 4'
      expect(page).not_to have_content 'question text 1'
      expect(page).not_to have_content 'question text 3'
      expect(page).not_to have_content 'Possible solution 1'
      expect(page).not_to have_content 'Possible solution 6'
    end

    scenario 'an admin can not see already added questions' do
      sign_in admin
      visit "/units/#{ unit.id }"
      question_links = all('a', :text => 'Add questions to lesson')
      question_links[0].click
      check "question_#{question_1.id}"
      check "question_#{question_3.id}"
      click_button "Update Lesson"
      question_links[1].click
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
      visit "/units/#{ unit.id }"
      question_links = all('a', :text => 'Add questions to lesson')
      question_links[0].click
      fill_in 'Question text', with: 'Solve $2+x=5$'
      fill_in 'Solution', with: '$x=2$'
      fill_in 'Difficulty level', with: 2
      fill_in 'Experience', with: 100
      click_button 'Create Question'
      "/units/#{ unit.id }"
      expect(page).to have_content 'Solve $2+x=5$'
      expect(page).to have_content '$x=2$'
    end
  end
end
