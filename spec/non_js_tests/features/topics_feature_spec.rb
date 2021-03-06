feature 'topics' do
  let!(:super_admin) { create_super_admin }
  let!(:course) { create_course }
  let!(:unit)   { create_unit course }
  let!(:unit_2) { create_unit course }
  let!(:topic_2)  { create_topic unit_2 }
  let!(:topic)  { create_topic unit }
  let!(:lesson) { create_lesson topic, 1, 'Published' }
  let!(:lesson_2) { create_lesson topic_2, 2, 'Published' }
  let!(:lesson_3) { create_lesson topic_2, 3, 'Published' }
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

  context 'topic level one exp derived lesson pass_experience' do
    scenario 'topic lessons have 0 pass experience' do
      expect(topic.level_one_exp).to eq 0
    end

    scenario 'topic lessosn have 200 combined pass experience' do
      lesson_2.questions = [question_1]
      lesson_2.save
      lesson_3.questions = [question_2]
      lesson_3.save

      expect(topic_2.level_one_exp).to eq 200
    end

    scenario 'default level one exp if no lessons present' do
      sign_in admin
      visit "/units/#{ unit.id }"
      click_link 'Add a new chapter'
      fill_in 'Name', with: 'Series'
      fill_in 'Description', with: 'Powers'
      fill_in 'Level multiplier', with: 1.5
      click_button 'Create Topic'
      expect(Topic.last.level_one_exp).to eq 9999
      expect(page).to have_content 'Series'
      expect(Topic.last.level_multiplier).to eq 1.5
      expect(current_path).to eq "/units/#{ unit.id }"
    end
  end

  context 'adding a topic' do
    scenario 'an admin can add a topic' do
      sign_in admin
      visit "/units/#{ unit.id }"
      click_link 'Add a new chapter'
      fill_in 'Name', with: 'Series'
      fill_in 'Description', with: 'Powers'
      fill_in 'Level multiplier', with: 1.5
      click_button 'Create Topic'
      expect(page).to have_content 'Series'
      expect(Topic.last.level_multiplier).to eq 1.5
      expect(Topic.last.level_one_exp).to eq 9999
      expect(current_path).to eq "/units/#{ unit.id }"
    end

    scenario 'cannot add a topic if not signed in' do
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Add a new chapter'
    end

    scenario 'cannot visit the add topic page unless signed in' do
      visit "/units/#{ unit.id }/topics/new"
      expect(current_path).to eq new_user_session_path
    end

    scenario 'cannot add a topic if signed in as a student' do
      sign_in student
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Add a new chapter'
    end

    scenario 'cannot visit the add topic page if signed in as a student' do
      sign_in student
      visit "/units/#{ unit.id }/topics/new"
      expect(current_path).to eq "/courses"
      expect(page).to have_content 'You are not authorized to access this page.'
    end
  end

  context 'updating topics' do
    scenario 'an admin can edit a topic' do
      sign_in admin
      visit "/topics/#{ topic.id }/edit"
      fill_in 'Name', with: 'New topic'
      fill_in 'Description', with: 'New topic desc'
      click_button 'Update Topic'
      expect(page).to have_content 'New topic'
      expect(current_path).to eq "/units/#{ unit.id }"
    end

    scenario 'when not signed in cannot see edit link' do
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Edit chapter'
    end

    scenario 'when not signed in cannot visit edit page' do
      visit "/topics/#{ topic.id }/edit"
      expect(current_path).to eq new_user_session_path
    end

    scenario 'a student cannot see edit link' do
      sign_in student
      visit "/units/#{ unit.id }"
      expect(page).to have_link 'Edit', count: 1
    end

    scenario 'a student cannot visit edit page' do
      sign_in student
      visit "/topics/#{ topic.id }/edit"
      expect(page).to have_content 'You are not authorized to access this page.'
      expect(current_path).to eq "/courses"
    end
  end

  context 'deleting topics' do
    scenario 'a super admin can delete a course' do
      sign_in super_admin
      visit "/units/#{ unit.id }"
      click_link 'Delete chapter'
      expect(page).not_to have_content topic.name
      expect(page).not_to have_content topic.description
      expect(page).to have_content 'Topic deleted successfully'
      expect(current_path).to eq "/units/#{ unit.id }"
    end

    scenario 'an admin do not see delete link' do
      sign_in admin
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Delete chapter'
    end

    scenario 'an admin can send delete request' do
      sign_in admin
      page.driver.submit :delete, "/topics/#{ topic.id }",{}
      expect(page).to have_content 'Topic deleted successfully'
      expect(current_path).to eq "/units/#{ unit.id }"
    end

    scenario 'when not signed in cannot see delete link' do
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Delete chapter'
    end

    scenario 'when not signed in cannot send delete request' do
      page.driver.submit :delete, "/topics/#{ topic.id }",{}
      expect(current_path).to eq new_user_session_path
    end

    scenario 'a student cannot see delete link' do
      sign_in student
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Delete chapter'
    end

    scenario 'a student cannot send a delete request' do
      sign_in student
      page.driver.submit :delete, "/topics/#{ topic.id }",{}
      expect(page).to have_content 'You are not authorized to access this page.'
      expect(current_path).to eq "/courses"
    end
  end

  context 'gaining exp' do
    scenario 'a student starts with 0 experience for a new topic' do
      lesson.questions = [question_1,question_2,question_3]
      lesson.save
      sign_in student
      srand(102)
      visit "/units/#{ unit.id }"
      expect(StudentTopicExp.current_exp(student,topic)).to eq 0
      expect(page).to have_content topic_exp_bar(student, topic, 0)
    end

    scenario 'a student gain topic experience for correct answer', js: true do
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
      expect(StudentTopicExp.current_exp(student,topic)).to eq 100
      expect(page).to have_content topic_exp_bar(student, topic, 0)
      expect(page).to have_content ' 100 / 100'
    end

    scenario 'a student gain more topic experience for another correct answer', js: true do
      lesson.questions = [question_1,question_2,question_3]
      lesson.save
      sign_in student
      srand(102)
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
      expect(StudentTopicExp.current_exp(student,topic)).to eq 100
      expect(page).to have_content topic_exp_bar(student, topic, 0)
      expect(page).to have_content ' 100 / 100'
    end

    scenario 'a student does not gain more topic experience for wrong answer', js: true do
      lesson.questions = [question_1,question_2,question_3]
      lesson.save
      sign_in student
      srand(102)
      visit "/units/#{ unit.id }"
      find("#chapter-collapsable-#{topic.id}").trigger('click')
      find("#lesson-collapsable-#{lesson.id}").trigger('click')
      wait_for_ajax
      page.choose("choice-#{choice_2.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      click_link 'Next question'
      wait_for_ajax

      page.choose("choice-#{choice_3.id}")
      click_button 'Submit Answer'
      wait_for_ajax
      expect(StudentTopicExp.current_exp(student,topic)).to eq 100
      expect(page).to have_content topic_exp_bar(student, topic, 0)
      expect(page).to have_content ' 100 / 100'
    end
  end


  context 'adding questions to chapters' do
    scenario 'an admin can add a question' do
      lesson.questions = [question_1]
      lesson.save
      sign_in admin
      expect(topic.questions.count).to eq 0
      visit "/topics/#{ topic.id }/new_question"
      check "question_#{question_2.id}"
      click_button 'Update Chapter'
      expect(page).to have_content 'Questions successfully added to topic.'
      expect(topic.questions.count).to eq 1
    end
  end
end
