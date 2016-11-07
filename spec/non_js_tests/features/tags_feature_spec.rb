feature "Tags" do
  let!(:admin)       { create_admin }
  let!(:super_admin) { create_super_admin }
  let!(:tag_1)       { create_tag("Edexcel") }
  let!(:tag_2)       { create_tag("MEI") }
  let!(:tag_3)       { create_tag("Linear Algebra") }

  context "#crud" do
    before(:each) do
      sign_in admin
      visit tags_path
    end

    scenario "create tag" do
      click_link 'add-new-tag'
      expect(current_path).to eq new_tag_path
      fill_in 'Name', with: 'Core 2'
      click_button 'Create Tag'
      expect(page).to have_content "Core 2"
      expect(page).to have_content "Tag has been successfully saved."
    end

    scenario "view all tags" do
      expect(page).to have_content "Edexcel"
      expect(page).to have_content "MEI"
      expect(page).to have_content "Linear Algebra"
    end

    scenario "edit tag" do
      click_link "edit-#{tag_1.id}"
      expect(current_path).to eq edit_tag_path(tag_1)
      fill_in 'Name', with: 'Core 1'
      click_button 'Update Tag'
      expect(current_path).to eq tags_path
      expect(page).to have_content "Core 1"
      expect(page).not_to have_content "Edexcel"
    end

    scenario "delete tag" do
      click_link "delete-#{tag_2.id}"
      expect(current_path).to eq tags_path
      expect(page).to have_content "Edexcel"
      expect(page).to have_content "Linear Algebra"
      expect(page).not_to have_content "MEI"
    end
  end

  context "tag validation" do
    before(:each) do
      sign_in admin
      visit tags_path
    end

    xscenario "cannot create tag without a name" do
      click_link "Add tag"
      click_button 'Create Tag'
      expect(current_path).to eq new_tag_path
    end

    xscenario "cannot update tag with empty field for name" do
      click_link "edit-#{tag_1.id}"
      fill_in 'Name', with: ""
      click_button 'Update Tag'
      expect(current_path).to eq edit_tag_path(tag_1)
    end
  end
end
