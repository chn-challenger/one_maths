require 'rails_helper'
require 'general_helpers'

feature 'questions' do
  let!(:admin)  { create_admin   }
  let!(:question_1){create_question(1)}
  let!(:choice_1){create_choice(question_1,1,false)}
  let!(:choice_2){create_choice(question_1,2,true)}
  let!(:question_2){create_question_with_order(2,"b1")}
  let!(:answer_2){create_answers(question_2,[['a=','+5,-8,7.1,6.21']])}

  context 'creating jobs' do
    scenario 'admin can create a job' do
      sign_in admin
      visit "/jobs"
      click_link 'Add A Job'
      fill_in "Title", with: "Quadratic Equation Application Question"
      fill_in "Description", with: "Very long description of the job"
      fill_in "Sample Question ID", with: "#{question_1.id}"
      click_button "Create Job"
      expect(page).to have_content 'Quadratic Equation Application Question'
      expect(page).to have_content 'Very long description of the job'
      expect(page).to have_content 'question text 2'
      expect(current_path).to eq "/jobs"
    end
  end

end
