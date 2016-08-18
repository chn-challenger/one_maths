require 'rails_helper'
require 'general_helpers'

feature 'questions' do
  context 'viewing list of all questions' do
    let!(:maker){create_maker}
    # let!(:question_1){create_question_1(maker)}
    # let!(:question_2){create_question_2(maker)}
    let!(:question_1){create_question(maker,1)}
    let!(:question_2){create_question(maker,2)}

    scenario 'when signed in as a maker display a list of questions' do
      sign_in_maker
      visit '/'
      click_link 'Questions'
      expect(page).to have_content "question text 1"
      expect(page).to have_content "question text 2"
      expect(page).to have_content "solution 1"
      expect(page).to have_content "solution 2"
    end

    scenario 'when not signed in as a maker, cannot see questions' do
      visit '/'
      expect(page).not_to have_link "Questions"
      visit '/questions'
      expect(page).not_to have_content "question text 1"
      expect(page).not_to have_content "question text 2"
      expect(page).not_to have_content "solution 1"
      expect(page).not_to have_content "solution 2"
    end
  end

  context 'adding questions' do
    let!(:maker){create_maker}

    scenario 'a maker adding a question' do
      sign_in_maker
      visit "/questions"
      click_link 'Add a question'
      fill_in 'Question text', with: 'Solve $2+x=5$'
      fill_in 'Solution', with: '$x=2$'
      click_button 'Create Question'
      expect(page).to have_content 'Solve $2+x=5$'
      expect(page).to have_content '$x=2$'
      expect(current_path).to eq "/questions"
    end

    scenario 'cannot add a question when not logged in as a maker' do
      visit '/questions'
      expect(page).not_to have_link 'Add a question'
      visit '/questions/new'
      expect(page).to have_content 'You must be logged in as a maker to add a lesson'
    end
  end

  context 'updating questions' do
    let!(:maker){create_maker}
    let!(:question_1){create_question(maker,1)}

    scenario 'a maker can update his own questions' do
      sign_in_maker
      visit "/questions"
      click_link 'Edit question'
      fill_in 'Question text', with: 'New question'
      fill_in 'Solution', with: 'New solution'
      click_button 'Update Question'
      expect(page).to have_content 'New question'
      expect(page).to have_content 'New solution'
      expect(current_path).to eq "/questions"
    end

    scenario "a maker cannot edit someone else's questions" do
      sign_up_tester
      visit "/questions/#{question_1.id}/edit"
      expect(page).not_to have_link 'Edit question'
      expect(page).to have_content 'You can only edit your own questions'
      expect(current_path).to eq "/questions"
    end
  end

  context 'deleting questions' do
    let!(:maker){create_maker}
    let!(:question_1){create_question(maker,1)}

    scenario 'a maker can delete their own questions' do
      sign_in_maker
      visit "/questions"
      click_link 'Delete question'
      expect(page).not_to have_content 'question text 1'
      expect(page).not_to have_content 'solution 1'
      expect(current_path).to eq "/questions"
    end

    scenario "a maker cannot delete another maker's questions" do
      sign_up_tester
      visit "/questions"
      expect(page).not_to have_link 'Delete question'
      page.driver.submit :delete, "/questions/#{question_1.id}",{}
      expect(page).to have_content 'Can only delete your own questions'
    end
  end
end
