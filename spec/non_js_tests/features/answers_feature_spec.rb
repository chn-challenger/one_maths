feature 'answers' do
  let!(:admin)  { create_admin   }
  let!(:student){ create_student }
  let!(:question_1){create_question(1)}
  let!(:answer_1){create_answer(question_1,1)}
  let!(:answer_2){create_answer(question_1,2, nil, nil, "1")}

  context 'Displaying answers' do
    before(:each) do
      hints = ['Global Hint 0', 'Global Hint 1']
      stub_const('AnswersHelper::ANSWER_HINTS', hints)
      # allow_any_instance_of(AnswersHelper).to receive(:load_hints).and_return(hints)
    end

    scenario 'should display answers when signed in as admin' do
      sign_in admin
      visit "/questions"
      fill_in "Lesson ID", with: 'all'
      click_button 'Filter by this Lesson ID'
      expect(current_path).to eq "/questions"
      expect(page).to have_content 'x1'
      expect(page).to have_content 'answer hint 1'
      expect(page).to have_content 'Order'
    end

    scenario 'displays hint from loaded config file' do
      sign_in admin
      visit "/questions"
      fill_in "Lesson ID", with: 'all'
      click_button 'Filter by this Lesson ID'
      expect(page).to have_content 'Hint Global Hint 1'
    end

    scenario 'should not display answers when not signed in' do
      visit "/questions"
      expect(current_path).to eq new_user_session_path
      expect(page).not_to have_content 'x1'
      expect(page).not_to have_content 'answer hint 1'
    end

    scenario 'should not display answers when signed in as a student' do
      sign_in student
      visit "/questions"
      expect(current_path).to eq "/"
      expect(page).not_to have_content 'x1'
      expect(page).not_to have_content 'answer hint 1'
    end
  end

  context 'adding answers' do
    before(:each) do
      hints = ['Global Hint 0', 'Global Hint 1']
      stub_const('AnswersHelper::ANSWER_HINTS', hints)
      # allow_any_instance_of(AnswersHelper).to receive(:load_hints).and_return(hints)
    end

    scenario 'create answer with order and global hint' do
      sign_in admin
      visit "/questions"
      fill_in "Lesson ID", with: 'all'
      click_button 'Filter by this Lesson ID'
      click_link 'Add an answer to question'
      fill_in 'answer_label_0', with: 'Dummy label'
      fill_in 'answer_solution_0', with: 'Dummy solution'
      select 'Global Hint 0', from: 'answer_hint_0'
      fill_in 'answer_order_0', with: 120
      click_button 'Save changes'
      expect(page).to have_content 'Dummy label'
      expect(page).to have_content 'Dummy solution'
      expect(page).to have_content 'Hint Global Hint 0'
      expect(page).to have_content 'Order 120'
    end

    scenario 'create answer with order and custom hint', js: true do
      sign_in admin
      visit "/questions"
      fill_in "Lesson ID", with: 'all'
      click_button 'Filter by this Lesson ID'
      click_link 'Add an answer to question'
      fill_in 'answer_label_0', with: 'Dummy label'
      fill_in 'answer_solution_0', with: 'Dummy solution'
      select 'Other', from: 'answer_hint_0'
      fill_in 'answer_hint_0', with: 'Custom Hint'
      fill_in 'answer_order_0', with: 120
      click_button 'Save changes'
      expect(page).to have_content 'Dummy label'
      expect(page).to have_content 'Dummy solution'
      expect(page).to have_content 'Hint Custom Hint'
      expect(page).to have_content 'Order 120'
    end

    scenario 'an admin can add an answer to a question' do
      sign_in admin
      visit "/"
      click_link "Add Question"
      click_link 'Add an answer to question'
      expect(page).to have_content "Label"
      expect(page).to have_content "Hint"
    end

    scenario 'when not logged on cannot add a answer' do
      visit "/questions"
      expect(page).not_to have_link 'Add an answer to question'
      visit "/questions/#{question_1.id}/answers/new"
      expect(current_path).to eq new_user_session_path
    end

    scenario 'a student cannot add a answer' do
      sign_in student
      visit "/questions"
      expect(page).not_to have_link 'Add an answer to question'
      visit "/questions/#{question_1.id}/answers/new"
      expect(page).to have_content 'You are not authorized to access this page.'
      expect(current_path).to eq "/"
    end
  end

  context 'updating answers' do
    scenario 'an admin can update answers' do
      sign_in admin
      visit "/"
      click_link "Add Question"
      click_link("edit-question-#{question_1.id}-answer-#{answer_1.id}")
      fill_in 'Label', with: 'x111'
      fill_in 'Solution', with: '222'
      fill_in 'Hint', with: 'No hints'
      click_button 'Update Answer'
      expect(page).to have_content 'x111'
      expect(current_path).to eq "/questions/new"
    end

    scenario "when not signed in cannot edit answers" do
      visit "/answers/#{answer_1.id}/edit"
      expect(page).not_to have_link 'Edit answer'
      expect(current_path).to eq new_user_session_path
    end

    scenario "when signed in as a student cannot edit answers" do
      sign_in student
      visit "/answers/#{answer_1.id}/edit"
      expect(page).not_to have_link 'Edit answer'
      expect(page).to have_content 'You do not have permission to edit an answer'
      expect(current_path).to eq "/"
    end
  end

  context 'deleting answers' do
    scenario 'an admin can delete answers' do
      sign_in admin
      visit "/"
      click_link "Add Question"
      click_link("delete-question-#{question_1.id}-answer-#{answer_1.id}")
      expect(page).not_to have_content 'x1'
      expect(current_path).to eq "/questions/new"
    end

    scenario "when not signed in cannot delete answers" do
      visit "/questions/new"
      expect(page).not_to have_link 'Delete answer'
      expect(current_path).to eq new_user_session_path
    end

    scenario "when signed in as a student cannot delete choices" do
      sign_in student
      visit "/questions/new"
      expect(page).not_to have_link 'Delete answer'
      page.driver.submit :delete, "/answers/#{answer_1.id}",{}
      expect(page).to have_content 'You do not have permission to delete an answer'
    end
  end
end
