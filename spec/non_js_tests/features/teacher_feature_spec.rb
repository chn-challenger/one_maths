feature 'teacher' do
  let(:teacher) { create_teacher }
  let(:student) { create_student }
  let!(:course) { create_course  }
  let!(:unit)   { create_unit course }
  let!(:topic)  { create_topic unit }
  let!(:lesson) { create_lesson topic, 1, 'Published' }


  describe "teacher invites student" do
    context 'teacher sends invitation to' do
      scenario 'existing user' do
        sign_in teacher
        visit teachers_path
        fill_in 'Student Email', with: student.email
        click_button 'Invite Student'
        expect(page).to have_content "Invitation to #{student.email} has been successfully sent."
        expect(student.invitation).not_to be nil
        expect(teacher.invites.count).to eq 1
      end

      scenario 'non-existant user' do
        sign_in teacher
        visit teachers_path
        fill_in 'Student Email', with: 'non@existant.user'
        click_button 'Invite Student'
        expect(page).to have_content "You have entered an invalid user email, please check and try again."
      end
    end

    context 'student has been sent an invite' do
      before(:each) {
        create_invitation(sender: teacher, invitee: student)
      }

      scenario 'student can view that he has been invited' do
        sign_in student
        expect(page).to have_content 'Pending Invitation'
      end

      scenario 'student accepts invitation' do
        sign_in student
        click_link 'Pending Invitation'
        click_link 'Accept'
        expect(page).to have_content "You have successfully accepted #{teacher.email} invitation!"
        expect(student.invitation).to be nil
        expect(teacher.students).to include(student)
      end

      scenario 'student declines invitation' do
        sign_in student
        click_link 'Pending Invitation'
        click_link 'Decline'
        expect(page).to have_content "You have declined #{teacher.email} invitation."
        expect(student.invitation).to be nil
        expect(teacher.students).not_to include(student)
      end
    end
  end

  describe "teacher sets homework" do
    scenario 'teacher selects student' do
      teacher.students << student
      sign_in teacher
      visit teachers_path
      select student.email, from: 'student_email'
      click_button 'View Student'
      expect(page).to have_content "Student #{student.email} has been selected."
    end

    scenario 'homework added to student', js: true do
      teacher.students << student
      sign_in teacher
      visit teachers_path
      select student.email, from: 'student_email'
      click_button 'View Student'

      find("#unit-#{unit.id}").trigger('click')
      find("#chapter-#{lesson.id}").trigger('click')
      find(:css, "#lesson-homework-#{lesson.id}").set(true)
      click_button 'Set Homework'
      expect(page).to have_content "Homework successfully set for #{student.email}"
      expect(student.homework).to include(lesson)
    end

    scenario 'remove lesson from homework', js: true do
      teacher.students << student
      student.homework << lesson

      sign_in teacher
      visit teachers_path
      select student.email, from: 'student_email'
      click_button 'View Student'

      expect(student.homework).to include(lesson)
      find("#unit-#{unit.id}").trigger('click')
      find("#chapter-#{lesson.id}").trigger('click')
      find(:css, "#lesson-homework-#{lesson.id}").set(false)
      click_button 'Set Homework'
      expect(page).to have_content "Homework successfully set for #{student.email}"
      expect(student.homework_ids).not_to include(lesson.id)
    end
  end
end
