require 'rails_helper'
require 'general_helpers'

feature 'questions' do
  context 'A lesson with no questions' do
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:unit){create_unit(course,maker)}
    let!(:topic){create_topic(unit,maker)}
    let!(:lesson){create_lesson(topic,maker)}

    scenario 'should display a prompt to add a question' do
      sign_in_maker
      visit "/units/#{unit.id}"
      expect(page).to have_link 'Add a question to lesson'
    end
  end

  context 'adding questions' do
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:unit){create_unit(course,maker)}
    let!(:topic){create_topic(unit,maker)}
    let!(:lesson){create_lesson(topic,maker)}

    scenario 'when not logged in cannot add a question' do
      visit "/units/#{unit.id}"
      expect(page).not_to have_link "Add a question to lesson"
    end

    scenario 'a maker adding a question to his lesson' do
      sign_in_maker
      visit "/units/#{unit.id}"
      click_link 'Add a question to lesson'
      fill_in 'Question text', with: 'Solve $2+x=5$'
      fill_in 'Solution', with: '$x=2$'
      click_button 'Create Question'
      expect(page).to have_content 'Solve $2+x=5$'
      expect(page).to have_content '$x=2$'
      expect(current_path).to eq "/units/#{unit.id}"
    end

    scenario 'a different maker cannot add a question' do
      sign_up_tester
      visit "/lessons/#{lesson.id}/questions/new"
      expect(page).not_to have_link "Add a question to lesson"
      expect(page).to have_content 'You can only add questions to your own lessons'
      expect(current_path).to eq "/units/#{unit.id}"
    end
  end

  context 'updating questions' do
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:unit){create_unit(course,maker)}
    let!(:topic){create_topic(unit,maker)}
    let!(:lesson){create_lesson(topic,maker)}
    let!(:question){create_question(lesson,maker)}

    scenario 'a maker can update his own questions' do
      sign_in_maker
      visit "/units/#{unit.id}"
      click_link 'Edit question'
      fill_in 'Question text', with: 'New question'
      fill_in 'Solution', with: 'New solution'
      click_button 'Update Question'
      expect(page).to have_content 'New question'
      expect(page).to have_content 'New solution'
      expect(current_path).to eq "/units/#{unit.id}"
    end

    scenario "a maker cannot edit someone else's questions" do
      sign_up_tester
      visit "/questions/#{question.id}/edit"
      expect(page).not_to have_link 'Edit question'
      expect(page).to have_content 'You can only edit your own questions'
      expect(current_path).to eq "/units/#{unit.id}"
    end
  end

  context 'deleting questions' do
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:unit){create_unit(course,maker)}
    let!(:topic){create_topic(unit,maker)}
    let!(:lesson){create_lesson(topic,maker)}
    let!(:question){create_question(lesson,maker)}

    scenario 'a maker can delete their own questions' do
      sign_in_maker
      visit "/units/#{unit.id}"
      click_link 'Delete question'
      expect(page).not_to have_content 'Solve $2+x=5$'
      expect(page).not_to have_content '$x = 3$'
      expect(current_path).to eq "/units/#{unit.id}"
    end

    scenario "a maker cannot delete another maker's questions" do
      sign_up_tester
      visit "/units/#{unit.id}"
      expect(page).not_to have_link 'Delete question'
      page.driver.submit :delete, "/questions/#{question.id}",{}
      expect(page).to have_content 'Can only delete your own questions'
    end
  end

  context 'showing random questions to non-owners' do
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:unit){create_unit(course,maker)}
    let!(:topic){create_topic(unit,maker)}
    let!(:lesson){create_lesson(topic,maker)}
    let!(:question1){create_question(lesson,maker)}
    let!(:question2){lesson.questions.create_with_maker({
      question_text:'Solve $x-3=8$',
      solution:'$x = 11$'},maker)}

    scenario 'owner maker can see all questions on the lesson' do
      sign_in_maker
      visit "/units/#{unit.id}"
      expect(page).to have_content 'Solve $2+x=5$'
      expect(page).to have_content '$x = 3$'
      expect(page).to have_content 'Solve $x-3=8$'
      expect(page).to have_content '$x = 11$'
    end

    scenario 'others a random question - question 1' do
      srand(100)
      visit "/units/#{unit.id}"
      expect(page).to have_content 'Solve $2+x=5$'
      expect(page).to have_link 'Show solution'
      expect(page).to have_content 'place holder'
      expect(page).not_to have_content '$x = 3$'
    end

    scenario 'others a random question - question 2', js: true do
      srand(300)
      visit "/units/#{unit.id}"
      click_link 'Show solution'
      expect(page).to have_content 'Solve $x-3=8$'
      expect(page).not_to have_content 'place holder'
      expect(page).to have_content '$x = 11$'
    end
  end

end
