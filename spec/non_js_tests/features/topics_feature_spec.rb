require 'rails_helper'


feature 'topics' do
  let!(:super_admin){create_super_admin}
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

  context 'topic level one exp' do
    scenario 'level one exp derived from 1 lesson pass exp' do
      expect(topic.level_one_exp).to eq 1000
    end

    scenario 'level one exp derived from 2 lessons pass exp' do
      sign_in admin
      visit "/units/#{ unit.id }"
      click_link "Add a lesson to chapter"
      fill_in 'Name', with: 'New lesson'
      fill_in 'Description', with: 'Lesson desc'
      fill_in 'Pass experience', with: 1999
      fill_in 'Sort order', with: 2
      click_button 'Create Lesson'
      expect(Topic.last.level_one_exp).to eq 2999
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
      expect(current_path).to eq "/units/#{ unit.id }"
      expect(page).to have_content 'You do not have permission to add a topic'
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
      expect(page).to have_content 'You do not have permission to edit a topic'
      expect(current_path).to eq "/units/#{ unit.id }"
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
      expect(page).to have_content 'You do not have permission to delete a topic'
      expect(current_path).to eq "/units/#{ unit.id }"
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
      expect(page).to have_content '0/1000'
    end

    scenario 'a student gain topic experience for correct answer' do
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
      expect(StudentTopicExp.current_exp(student,topic)).to eq 100
      visit "/units/#{ unit.id }"
      expect(page).to have_content '100/1000'
    end

    scenario 'a student gain more topic experience for another correct answer' do
      lesson.questions = [question_1,question_2,question_3]
      lesson.save
      sign_in student
      srand(102)
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
      expect(StudentTopicExp.current_exp(student,topic)).to eq 225
      visit "/units/#{ unit.id }"
      expect(page).to have_content '225/1000'
    end

    scenario 'a student does not gain more topic experience for wrong answer' do
      lesson.questions = [question_1,question_2,question_3]
      lesson.save
      sign_in student
      srand(102)
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
      expect(StudentTopicExp.current_exp(student,topic)).to eq 100
      visit "/units/#{ unit.id }"
      expect(page).to have_content '100/1000'
    end
  end

  context 'adding questions to chapters' do
    scenario 'an admin can add a question' do
      sign_in student
      visit "/units/#{unit.id }"
      expect(page).not_to have_content 'question text 1'
      click_link 'Sign out'
      sign_in admin
      visit "/topics/#{ topic.id }/new_question"
      check "question_#{question_1.id}"
      click_button 'Update Chapter'
      click_link 'Sign out'
      sign_in student
      visit "/units/#{unit.id }"
      expect(page).to have_content 'question text 1'
    end
  end
end
