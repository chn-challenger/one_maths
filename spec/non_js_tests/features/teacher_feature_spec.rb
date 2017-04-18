feature 'teacher' do
  let(:teacher) { create_teacher }
  let(:student) { create_student }
  let!(:course) { create_course('Private', :private, teacher.id) }
  let!(:unit)   { create_unit course }
  let!(:topic)  { create_topic unit }
  let!(:lesson) { create_lesson topic, 1, 'Published' }
  let!(:super_admin) { create_super_admin }
  let!(:course_p) { create_course }
  let!(:unit_p)   { create_unit course_p }
  let!(:topic_p)  { create_topic unit_p }
  let!(:lesson_p) { create_lesson topic, "", 'Published' }


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

    xscenario 'homework added to student', js: true do
      teacher.students << student
      sign_in teacher
      visit teachers_path
      select student.email, from: 'student_email'
      click_button 'View Student'
      wait_for_ajax
      find("#unit-#{unit.id}").trigger('click')
      wait_for_ajax
      find(:css, "#chapter-#{topic.id}").trigger('click')
      find(:css, "#lesson-homework-#{lesson.id}").set(true)
      select '3', from: "#topic-level-#{topic.id}"
      find(:css, "#topic-#{topic.id}").set 100
      click_button 'Set Homework'
      expect(page).to have_content "Homework successfully set for #{student.email}"
      expect(student.homework.count).to eq 2
      expect(student.homework.last.target_exp).to eq 400
    end

    xscenario 'remove lesson from homework', js: true do
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

  describe 'own course' do
    before :each do
      teacher.students << student
    end

    it "add students to course", js: true do
      expect(course.users).to eq []
      sign_in teacher
      visit course_path(course)
      find(:css, "#add-students").trigger('click')
      wait_for_ajax
      check student.email
      click_button 'Update Course'
      expect(current_path).to eq courses_path
    end
  end
end
