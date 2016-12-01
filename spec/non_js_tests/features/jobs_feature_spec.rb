require 'rails_helper'
require 'general_helpers'

feature 'job' do
  let!(:admin)  { create_admin   }
  let!(:super_admin) { create_super_admin }
  let!(:question_writer){ create_question_writer(1) }
  let!(:question_writer){ create_question_writer(2) }
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
      fill_in 'Number of questions', with: 4
      fill_in "Price", with: "10.50"
      click_button "Create Job"
      expect(page).to have_link "View job #{Job.last.id}"
      expect(page).to have_content 'Very long description of the job'
      expect(page).to have_content '2 days'
      expect(page).to have_content '£10.50'
      expect(Job.last.job_questions.size).to eq 4
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
      expect(page).to have_content 'Very long description of the job'
      expect(page).to have_content 'You have not entered valid Example ID please update the job.'
      expect(current_path).to eq jobs_path
    end

    scenario 'student cannot create a job' do
      sign_in student
      visit "/jobs"
      expect(page).not_to have_link 'Add A Job'
      expect(page).to have_content 'You are not authorized to access this page.'
      expect(current_path).to eq root_path
    end

    scenario 'cannot create a job when not logged on' do
      visit "/jobs"
      expect(current_path).to eq new_user_session_path
      visit new_job_path
      expect(current_path).to eq new_user_session_path
    end

    scenario 'cannot create a job as a question_writer' do
      sign_in question_writer
      visit jobs_path
      expect(page).not_to have_link 'Add job'
      visit new_job_path
      expect(current_path).to eq root_path
      expect(page).to have_content 'You are not authorized to access this page.'
    end
  end

  context 'editing and deleting jobs' do
    let!(:job_1) { create_job_via_post("Job 1",
                                       "Job description 1",
                                       question_1.id, 10, 2, 3
                   ) }
    let!(:job_2) { create_job_via_post("Job 2",
                                       "Job description 2",
                                       question_2.id, 12, 3, 3
                   ) }

    scenario 'editing a job' do
      sign_in admin
      visit "/jobs"
      click_link "View job #{job_1.id}"
      expect(page).to have_content job_1.name
      expect(page).to have_content job_1.duration
      click_link "Edit Job"
      expect(current_path).to eq "/jobs/#{job_1.id}/edit"
      fill_in "Name", with: "New job name"
      select "10", from: "Duration"
      click_button "Update Job"
      expect(page).to have_content "New job name"
      expect(page).to have_content "10"
    end

    scenario 'can\'t delete job if not super admin' do
      sign_in admin
      visit "/jobs"
      expect(page).to have_link "View job #{job_1.id}"
      expect(page).not_to have_link "Delete #{job_1.id}"
    end

    scenario 'deleting a job only as super admin' do
      sign_in super_admin
      visit "/jobs"
      expect(page).to have_link "View job #{job_1.id}"
      expect(page).to have_content job_1.description
      click_link "Delete job #{job_1.id}"
      expect(page).not_to have_link "View job #{job_1.id}"
      expect(page).not_to have_content job_1.description
    end

    scenario 'delete a job while still assigned' do
      assign_job(job_1, question_writer)
      sign_in super_admin
      visit "/jobs"
      expect(page).to have_link "View job #{job_1.id}"
      expect(page).to have_content job_1.description
      expect(page).to have_content "Assigned: To #{question_writer.id}"
      click_link "Delete job #{job_1.id}"
      expect(page).not_to have_link "View job #{job_1.id}"
      expect(page).not_to have_content job_1.description
    end

    scenario 'question writer cannot see crud links' do
      sign_in question_writer
      visit "/jobs"
      expect(page).not_to have_link "Delete job #{job_1.id}"
      expect(page).not_to have_link 'View Archive'
      click_link "View job #{job_1.id}"
      expect(page).not_to have_link 'Accept Submission'
      expect(page).not_to have_link 'Unassign Job'
      expect(page).not_to have_link "Edit Job"
      click_link 'Accept Job'
      expect(page).not_to have_link 'Accept Submission'
      expect(page).not_to have_link 'Unassign Job'
      expect(page).not_to have_link "Edit Job"
      expect(page).to have_link 'View Questions'
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
      expect(current_path).to eq new_user_session_path
    end

    scenario 'student cannot view jobs' do
      sign_in student
      visit "/jobs"
      expect(current_path).to eq root_path
      expect(page).to have_content 'You are not authorized to access this page.'
    end

    context 'viewing an individual job' do
      scenario 'a question_writer can view details of a job' do
        sign_in question_writer
        visit "/jobs"
        click_link "View job #{job_1.id}"
        expect(page).to have_content job_1.description
        expect(page).to have_content job_1.duration
        expect(page).to have_content 'Open'
        expect(page).to have_content 'Accept Job'
        expect(page).to have_content question_1.question_text
        expect(page).to have_content question_1.solution
      end
    end
  end

  context "#accepting jobs" do
    let!(:job_1) { create_job_via_post("Quadratic Equation Application Question",
                                       "Very long description of the job",
                                       question_1.id, 10.50, 2, 3
                   ) }
    let!(:job_2) { create_job_via_post("Mechanics 1",
                                       "A wall of text meets the viewer.",
                                       question_2.id, 12, 3, 3
                   ) }

    scenario "question writer accepts a job" do
      Timecop.freeze(Time.now)
      sign_in question_writer
      visit jobs_path
      click_link "View job #{job_1.id}"
      click_link "Accept Job"
      expect(current_path).to eq job_path(job_1)
      expect(page).to have_content job_1.description
      expect(page).to have_content (job_1.updated_at + job_1.duration.days).strftime("Due on %m/%d/%Y at %I:%M%p")
      expect(page).to have_link "Cancel Job"
      expect(page).to have_button "View Example Question"
      expect(page).to have_content question_1.id
      Timecop.return
    end

    context "#questions" do
      before(:each) do
        sign_in question_writer
        visit jobs_path
        click_link "View job #{job_1.id}"
        click_link "Accept Job"
      end

      scenario "question writer views job questions" do
        click_link "View Questions"
        expect(current_path).to eq questions_path
        expect(page).not_to have_link "Add a questions"
        expect(page).to have_content (job_1.job_questions.first.experience), count: 3
        expect(page).to have_content "Lesson 1", count: 3
      end
    end

    scenario "admin can view accepted jobs" do
      sign_in question_writer
      visit jobs_path
      click_link "View job #{job_1.id}"
      click_link "Accept Job"
      sign_out
      sign_in admin
      visit jobs_path
      expect(page).to have_content job_1.description
      expect(page).to have_content "Assigned: To #{question_writer.id}"
    end

    scenario "question writer cancels a job" do
      sign_in question_writer
      visit jobs_path
      click_link "View job #{job_1.id}"
      click_link "Accept Job"
      click_link "Cancel Job"
      expect(current_path).to eq jobs_path
      expect(page).to have_content "You have successfully canceled the job."
    end

    scenario "question writer can see own accepted job" do
      sign_in question_writer
      visit jobs_path
      expect(page).to have_content job_1.description
      click_link "View job #{job_1.id}"
      click_link "Accept Job"
      visit jobs_path
      expect(page).to have_link "View assigned #{job_1.id}"
      expect(page).to have_content job_1.name
      expect(page).not_to have_content job_1.description
    end

    scenario "job expired" do
      assign_job(job_1, question_writer)
      sign_in admin
      visit "/jobs"
      expect(page).to have_content "Assigned: To #{question_writer.id}"
      Timecop.travel(Time.now + 3.days)
      visit "/jobs"
      expect(page).not_to have_content "Assigned: To #{question_writer.id}"
      Timecop.return
    end
  end

  context '#job_commenting' do
    let!(:job_1) { create_job_via_post("Quadratic Equation Application Question",
                                       "Very long description of the job",
                                       question_1.id, 10.50, 2, 3
                   ) }
    let!(:job_2) { create_job_via_post("Mechanics 1",
                                       "A wall of text meets the viewer.",
                                       question_2.id, 12, 3, 3
                   ) }

    before(:each) do
      assign_job(job_1, question_writer)
      complete_job_questions(job_1, 1)
      add_choices_answers(job_1)
    end

    scenario 'admin can comment on a job' do
      sign_in admin
      visit "/jobs/#{job_1.id}"
      fill_in 'Comment', with: 'This is an admin comment.'
      click_button 'Comment'
      expect(page).to have_content 'This is an admin comment.'
      expect(page).to have_content admin.email
    end

    scenario 'question writer can comment on a job' do
      sign_in question_writer
      visit "/jobs/#{job_1.id}"
      fill_in 'Comment', with: 'This is a question writer comment.'
      click_button 'Comment'
      expect(page).to have_content 'This is a question writer comment.'
      expect(page).to have_content question_writer.email
    end

    context 'question writer and admin can exchange comments' do
      before(:each) do
        sign_in admin
        visit "/jobs/#{job_1.id}"
        fill_in 'Comment', with: 'This is an admin comment.'
        click_button 'Comment'
        sign_out

        sign_in question_writer
        visit "/jobs/#{job_1.id}"
        fill_in 'Comment', with: 'This is a question writer comment.'
        click_button 'Comment'
        sign_out
      end

      scenario 'admin views QW\'s comment' do
        sign_in admin
        visit "/jobs/#{job_1.id}"
        expect(page).to have_content 'This is a question writer comment.'
        expect(page).to have_content question_writer.email
      end

      scenario 'QW views admin\'s comment' do
        sign_in question_writer
        visit "/jobs/#{job_1.id}"
        expect(page).to have_content 'This is an admin comment.'
        expect(page).to have_content admin.email
      end
    end
  end

  context '#submitting a finished job' do
    let!(:job_1) { create_job_via_post("Quadratic Equation Application Question",
                                       "Very long description of the job",
                                       question_1.id, 10.50, 2, 3
                   ) }
    let!(:job_2) { create_job_via_post("Mechanics 1",
                                       "A wall of text meets the viewer.",
                                       question_2.id, 12, 3, 3
                   ) }

    scenario 'question_writer submits a job' do
      sign_in question_writer
      assign_job(job_1, question_writer)
      visit "/jobs/#{job_1.id}"
      complete_job_questions(job_1, 1)
      add_choices_answers(job_1)
      visit "/jobs/#{job_1.id}"
      expect(page).to have_link 'Submit Job'
      click_link 'Submit Job'
      expect(page).to have_content 'Pending Review'
    end

    scenario 'admin gets notified of submitted job and archive it' do
      assign_job(job_1, question_writer)
      sign_in admin
      visit root_path
      expect(page).to have_css '#pending-review'
      expect(page).to have_link '0'
      sign_out

      sign_in question_writer
      complete_job_questions(job_1, 1)
      add_choices_answers(job_1)
      visit "/jobs/#{job_1.id}"
      expect(page).to have_link 'Submit Job'
      click_link 'Submit Job'
      sign_out

      sign_in admin
      expect(page).to have_link '1'
      click_link '1'
      expect(current_path).to eq '/job/review'
      expect(page).to have_content job_1.description
      click_link "View job #{job_1.id}"
      click_link 'Accept Submission'
      expect(page).to have_link '0'
      visit '/job/review'
      expect(page).not_to have_content job_1.description
      visit '/job/archive'
      expect(page).to have_content job_1.description
    end

    context 'test a job' do
      before(:each) do
        sign_in question_writer
        assign_job(job_2, question_writer)
        complete_job_questions(job_2, 1)
        visit "/jobs/#{job_2.id}"
      end

      scenario 'cannot test unless all questions have answers/choices' do
        expect(page).to have_content 'In Progress', count: 3
        expect(page).not_to have_link 'Submit Job'
      end

      scenario 'after all question are complete can visit test unit' do
        add_choices_answers(job_2)
        visit "/jobs/#{job_2.id}"
        expect(page).to have_content 'Complete', count: 3
        expect(page).to have_link 'Submit Job'
        expect(page).to have_link 'Test'
        click_link 'Test'
        expect(current_path).to eq "/units/#{job_2.unit.id}"
        expect(page).to have_content "Test Chapter Job-#{job_2.id}"
      end

      scenario 'admin can test job questions' do
        add_choices_answers(job_2)
        sign_out
        sign_in admin
        visit "/jobs/#{job_2.id}"
        click_link 'Test'
        expect(current_path).to eq "/units/#{job_2.unit.id}"
        expect(page).to have_content "Test Chapter Job-#{job_2.id}"
      end
    end

    context 'approve a submitted job' do
      before(:each) do
        sign_in question_writer
        assign_job(job_2, question_writer)
        complete_job_questions(job_2, 1)
        add_choices(job_2)
        visit "/jobs/#{job_2.id}"
        expect(page).to have_link 'Submit Job'
        click_link 'Submit Job'
        sign_out
      end

      scenario 'as an admin' do
        sign_in admin
        expect(page).to have_link '1'
        click_link '1'
        click_link "View job #{job_2.id}"
        expect(page).to have_link 'Accept Submission'
        click_link 'Accept Submission'
        expect(page).to have_link '0'
        job_questions = job_2.job_questions
        job_q_text = job_questions.map { |q| q.question_text }
        job_q_choices = job_questions.map { |q| q.choices.first.content}
        expect(job_questions).not_to include(Question.last)
        expect(job_q_text).to include(Question.last.question_text)
        expect(job_q_choices).to include(Question.last.choices.first.content)
      end
    end
  end

end
