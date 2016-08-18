require 'rails_helper'
require 'general_helpers'

feature 'choices' do
  context 'Displaying choices' do
    let!(:maker){create_maker}
    let!(:question_1){create_question(maker,1)}
    let!(:choice){create_choice(question_1,maker,1)}

    scenario 'should display choices' do
      sign_in_maker
      visit "/questions"
      expect(current_path).to eq "/questions"
      expect(page).to have_content 'Possible solution 1'
    end
  end

  context 'adding choices' do
    let!(:maker){create_maker}
    let!(:question_1){create_question(maker,1)}

    scenario 'when not logged in cannot add a choice' do
      visit "/questions"
      expect(page).not_to have_link 'Add a choice to question'
    end

    scenario 'a maker adding a choice to his question' do
      sign_in_maker
      visit "/questions"
      click_link 'Add a choice to question'
      fill_in 'Content', with: 'Possible solution 1'
      select 'Mark as the right choice', from: 'choice_correct'
      click_button 'Create Choice'
      expect(page).to have_content 'Possible solution 1'
      expect(current_path).to eq "/questions"
    end

    scenario 'a different maker cannot add a choice' do
      sign_up_tester
      visit "/questions"
      expect(page).not_to have_link "Add a question to lesson"
      visit "/questions/#{question_1.id}/choices/new"
      expect(page).to have_content 'You can only add choices to your own questions'
      expect(current_path).to eq "/questions"
    end
  end

  context 'updating choices' do
    let!(:maker){create_maker}
    let!(:question_1){create_question(maker,1)}
    let!(:choice){create_choice(question_1,maker,1)}

    scenario 'a maker can update his own questions' do
      sign_in_maker
      visit "questions"
      click_link 'Edit choice'
      fill_in 'Content', with: 'The correct answer'
      select 'Mark as the right choice', from: 'choice_correct'
      click_button 'Update Choice'
      expect(page).to have_content 'The correct answer'
      expect(current_path).to eq "/questions"
    end

    scenario "a maker cannot edit someone else's choices" do
      sign_up_tester
      visit "/choices/#{choice.id}/edit"
      expect(page).not_to have_link 'Edit choice'
      expect(page).to have_content 'You can only edit your own choices'
      expect(current_path).to eq "/questions"
    end
  end

  context 'deleting choices' do
    let!(:maker){create_maker}
    let!(:question_1){create_question(maker,1)}
    let!(:choice){create_choice(question_1,maker,1)}

    scenario 'a maker can delete their own choices' do
      sign_in_maker
      visit "/questions"
      click_link 'Delete choice'
      expect(page).not_to have_content 'Possible solution 1'
      expect(current_path).to eq "/questions"
    end

    scenario "a maker cannot delete another maker's choices" do
      sign_up_tester
      visit "/questions"
      expect(page).not_to have_link 'Delete choice'
      page.driver.submit :delete, "/choices/#{choice.id}",{}
      expect(page).to have_content 'Can only delete your own choices'
    end
  end

end
