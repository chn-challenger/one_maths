feature "admin interface" do
  before(:each) do
    let!(:super_admin) { create_super_admin }
    let!(:admin)       { create_admin }
    let!(:student)     { create_student }
    let!(:student_2)   { create_student_2 }
  end

  context "#view all users" do
    scenario "admin and super admin can view all users" do
      
    end
  end
end
