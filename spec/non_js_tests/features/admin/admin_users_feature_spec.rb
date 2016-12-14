feature "admin interface" do
    let!(:super_admin) { create_super_admin }
    let!(:admin)       { create_admin }
    let!(:student)     { create_student }
    let!(:student_2)   { create_student_2 }

  context "#view all users" do
    scenario "view all users except admins and super_admins when logged in as admin" do
        sign_in admin
        visit admin_users_path
        expect(page).to have_content student.email
        expect(page).to have_content student_2.email
        expect(page).not_to have_content admin.email
        expect(page).not_to have_content super_admin.email
    end

    scenario "view all users except super admins when logged in as super admin" do
      sign_in super_admin
      visit admin_users_path
      expect(page).to have_content student.email
      expect(page).to have_content student_2.email
      expect(page).to have_content admin.email
      expect(page).not_to have_content super_admin.email
    end
  end

  context "#edit user" do
    before(:each) do
      sign_in super_admin
      visit admin_users_path
    end

    scenario "edit user username details as admin/super" do
      expect(page).to have_content 'IronMan'
      click_link "edit-user-#{student.id}"
      fill_in 'Username', with: "Jacky"
      click_button 'Update'
      expect(page).to have_content 'Jacky'
      expect(page).not_to have_content 'IronMan'
    end

    scenario "demote user to student while logged in as super admin" do
      expect(page).to have_content('admin', count: 2)
      expect(page).to have_content('student', count: 4)
      click_link "edit-user-#{admin.id}"
      select 'student', from: 'user_role'
      click_button 'Update'
      expect(page).to have_content('student', count: 5)
    end

    scenario 'make a student account into tester' do
      expect(page).to have_content('admin', count: 2)
      expect(page).to have_content('student', count: 4)
      expect(page).not_to have_content('tester')
      click_link "edit-user-#{student.id}"
      select 'tester', from: 'user_role'
      click_button 'Update'
      expect(page).to have_content('admin', count: 2)
      expect(page).to have_content('student', count: 4)
      expect(page).to have_content('tester')
    end
  end

  context "#delete user" do
    before(:each) do
      sign_in super_admin
      visit admin_users_path
    end

    scenario "super admin deletes one of the students", js: true do
      expect(page).to have_content('student', count: 4)
      expect(page).to have_content student.username
      page.accept_confirm { click_link "del-user-#{student.id}" }
      expect(page).not_to have_content student.username
      expect(page).to have_content('student', count: 2)
    end
  end
end
