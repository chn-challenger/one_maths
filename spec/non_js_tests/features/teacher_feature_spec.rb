feature 'tester' do
  let(:teacher) { create_teacher }
  let(:student) { create_student }

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
      end

      scenario 'student declines invitation' do
        sign_in student
        click_link 'Pending Invitation'
        click_link 'Decline'
        expect(page).to have_content "You have declined #{teacher.email} invitation."
      end
    end
  end

end
