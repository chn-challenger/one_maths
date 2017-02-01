feature 'tester' do
  let(:teacher) { create_teacher }
  let(:student) { create_student }

  describe "teacher invites student" do
    context 'teacher sneds invitation to' do
      scenario 'existing user' do
        sign_in teacher
        visit teachers_path
        fill_in 'Student Email', with: student.email
        click_button 'Invite Student'
        expect(page).to have_content "Successfully sent invitation to #{student.email}"
      end

      scenario 'non-existant user' do
        sign_in teacher
        visit teachers_path
        fill_in 'Student Email', with: 'non@existant.user'
        click_button 'Invite Student'
        expect(page).to have_content "You have entered an invalid user email, please check and try again."
      end
    end
  end

end
