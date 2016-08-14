require 'rails_helper'
require 'general_helpers'

feature 'choices' do
  context 'A question with no choices' do
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:unit){create_unit(course,maker)}
    let!(:topic){create_topic(unit,maker)}
    let!(:lesson){create_lesson(topic,maker)}
    let!(:question){create_question(lesson,maker)}

    scenario 'should display a prompt to add a choice' do
      sign_in_maker
      visit "/units/#{unit.id}"
      expect(page).to have_link 'Add a choice to question'
    end
  end

  context 'adding choices' do
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:unit){create_unit(course,maker)}
    let!(:topic){create_topic(unit,maker)}
    let!(:lesson){create_lesson(topic,maker)}
    let!(:question){create_question(lesson,maker)}

    scenario 'when not logged in cannot add a choice' do
      visit "/units/#{unit.id}"
      expect(page).not_to have_link 'Add a choice to question'
    end

    scenario 'a maker adding a choice to his question' do
      sign_in_maker
      visit "/units/#{unit.id}"
      click_link 'Add a choice to question'
      fill_in 'Content', with: 'Possible solution 1'
      select 'Mark as the right choice', from: 'choice_correct'
      click_button 'Create Choice'
      expect(page).to have_content 'Possible solution 1'
      expect(current_path).to eq "/units/#{unit.id}"
    end

    scenario 'a different maker cannot add a choice' do
      sign_up_tester
      visit "/units/#{unit.id}"
      expect(page).not_to have_link "Add a question to lesson"
      visit "/questions/#{question.id}/choices/new"
      expect(page).to have_content 'You can only add choices to your own questions'
      expect(current_path).to eq "/units/#{unit.id}"
    end
  end


end
