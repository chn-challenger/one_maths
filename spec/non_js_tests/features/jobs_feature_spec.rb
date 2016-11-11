require 'rails_helper'
require 'general_helpers'

feature 'questions' do
  let!(:admin)  { create_admin   }
  let!(:question_writer){ create_question_writer }
  let!(:student){ create_student }
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
      fill_in "Name", with: "Quadratic Equation Application Question"
      fill_in "Description", with: "Very long description of the job"
      fill_in "Example", with: "#{question_1.id}"
      select "2", from: "Duration"
      fill_in "Price", with: "10.50"
      click_button "Create Job"
      expect(page).to have_link "View job #{Job.last.id}"
      expect(page).to have_content 'Very long description of the job'
      expect(page).to have_content '2 days'
      expect(page).to have_content '£10.50'
      expect(current_path).to eq "/jobs"
    end

    scenario 'creating job with an invalid example id' do
      sign_in admin
      visit "/jobs"
      click_link 'Add A Job'
      fill_in "Name", with: "Quadratic Equation Application Question"
      fill_in "Description", with: "Very long description of the job"
      fill_in "Example", with: "11111"
      click_button "Create Job"
      expect(page).not_to have_content 'Quadratic Equation Application Question'
      expect(page).not_to have_content 'Very long description of the job'
      expect(page).not_to have_content 'question text'
      expect(page).to have_content 'You need to enter valid Example ID.'
      expect(current_path).to eq "/jobs/new"
    end

    scenario 'student cannot create a job' do
      sign_in student
      visit "/jobs"
      expect(page).not_to have_link 'Add A Job'
      expect(page).to have_content 'You are being redirected.'
      expect(page.status_code).to eq 403
    end

    scenario 'cannot create a job when not logged on' do
      visit "/jobs"
      expect(page).not_to have_link 'Add A Job'
      visit new_job_path
      expect(page).not_to have_button 'Create Job'
    end
  end

  context 'viewing jobs' do
    let!(:job_1){create_job(1,question_1.id)}
    let!(:job_2){create_job(2,question_2.id)}

    scenario 'a question_writer can view list of jobs' do
      sign_in question_writer
      visit "/jobs"
      expect(page).to have_content job_1.description
      expect(page).to have_content job_2.description
    end

    scenario 'not signed in cannot view jobs' do
      visit "/jobs"
      expect(page).not_to have_content 'Job 1'
      expect(page).not_to have_content 'Job 2'
    end

    scenario 'student cannot view jobs' do
      sign_in student
      visit "/jobs"
      expect(page).not_to have_content 'Job 1'
      expect(page).not_to have_content 'Job 2'
    end
  end

  context 'viewing an individual job' do
    let!(:job_1){create_job(1,question_1.id)}
    let!(:job_2){create_job(2,question_2.id)}

    scenario 'a question_writer can view details of a job' do
      # sign_in question_writer
      # visit "/jobs"
      # click_link "View job #{job_1.id}"
      # expect(page).to have_content 'Job 1 description'
    end
  end



end
