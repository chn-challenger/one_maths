require 'rails_helper'
require 'general_helpers'

feature 'lessons' do
  context 'A course unit with no topics' do
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:unit){create_unit(course,maker)}
    let!(:topic){create_topic(unit,maker)}

    scenario 'should display a prompt to add a lesson' do
      sign_in_maker
      visit "/units/#{unit.id}"
      expect(page).to have_link 'Add a lesson to chapter'
    end
  end

  context 'adding lessons' do
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:unit){create_unit(course,maker)}
    let!(:topic){create_topic(unit,maker)}

    scenario 'when not logged in cannot add a lesson' do
      visit "/units/#{unit.id}"
      expect(page).not_to have_link "Add a lesson to chapter"
    end

    scenario 'a maker adding a lesson to his topic' do
      sign_in_maker
      visit "/units/#{unit.id}"
      click_link "Add a lesson to chapter"
      fill_in 'Name', with: 'Index multiplication'
      fill_in 'Description', with: 'times divide power again of indices'
      fill_in 'Video', with: "0QjF6A3Zwkk"
      click_button 'Create Lesson'
      expect(page).to have_content 'Index multiplication'
      expect(current_path).to eq "/units/#{unit.id}"
    end

    scenario 'a different maker cannot add a lesson' do
      sign_up_tester
      visit "/topics/#{topic.id}/lessons/new"
      expect(page).not_to have_link "Add a lesson to chapter"
      expect(page).to have_content 'You can only add lessons to your own topics'
      expect(current_path).to eq "/units/#{unit.id}"
    end
  end

  context 'updating lessons' do
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:unit){create_unit(course,maker)}
    let!(:topic){create_topic(unit,maker)}
    let!(:lesson){create_lesson(topic,maker)}

    scenario 'a maker can update his own lessons' do
      sign_in_maker
      visit "/units/#{unit.id}"
      click_link 'Edit lesson'
      fill_in 'Name', with: 'A lesson'
      fill_in 'Description', with: 'basic lesson'
      fill_in 'Video', with: 'QiI9exfA'
      click_button 'Update Lesson'
      expect(page).to have_content 'A lesson'
      expect(current_path).to eq "/units/#{unit.id}"
    end

    scenario "a maker cannot edit someone else's lessons" do
      sign_up_tester
      visit "/lessons/#{lesson.id}/edit"
      expect(page).not_to have_link 'Edit lesson'
      expect(page).to have_content 'You can only edit your own lessons'
      expect(current_path).to eq "/units/#{unit.id}"
    end
  end

  context 'deleting lessons' do
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:unit){create_unit(course,maker)}
    let!(:topic){create_topic(unit,maker)}
    let!(:lesson){create_lesson(topic,maker)}

    scenario 'a maker can delete their own lessons' do
      sign_in_maker
      visit "/units/#{unit.id}"
      click_link 'Delete lesson'
      expect(page).not_to have_content 'Index multiplication'
      expect(current_path).to eq "/units/#{unit.id}"
    end

    scenario "a maker cannot delete another maker's lessons" do
      sign_up_tester
      visit "/units/#{unit.id}"
      expect(page).not_to have_link 'Delete Index multiplication'
      page.driver.submit :delete, "/lessons/#{lesson.id}",{}
      expect(page).to have_content 'Can only delete your own lessons'
    end
  end

  context 'adding questions to lessons' do
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:unit){create_unit(course,maker)}
    let!(:topic){create_topic(unit,maker)}
    let!(:lesson){create_lesson(topic,maker)}
    let!(:question_1){create_question(maker,1)}
    let!(:choice_1){create_choice(question_1,maker,1)}
    let!(:choice_2){create_choice(question_1,maker,2)}
    let!(:question_2){create_question(maker,2)}
    let!(:choice_3){create_choice(question_2,maker,3)}
    let!(:choice_4){create_choice(question_2,maker,4)}
    let!(:question_3){create_question(maker,2)}
    let!(:choice_5){create_choice(question_2,maker,5)}
    let!(:choice_6){create_choice(question_2,maker,6)}

    scenario 'no questions added' do
      sign_in_maker
      visit "/units/#{unit.id}"
      expect(page).not_to have_content 'question text'
    end

    scenario 'can select and add questions from bank to the lesson' do
      sign_in_maker
      visit "/units/#{unit.id}"
      click_link "Add questions to lesson"
      check "question_#{question_1.id}"
      click_button "Update Lesson"
      expect(page).to have_content 'question text 1'
      expect(page).to have_content 'solution 1'
      expect(page).to have_content 'Possible solution 1'
      expect(page).to have_content 'Possible solution 2'
      expect(page).not_to have_content 'Possible solution 3'
    end
  end

end
