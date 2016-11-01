feature "Catalogue" do
  let!(:admin)       { create_admin }
  let!(:super_admin) { create_super_admin }
  let!(:image)       { create_image('Test 1') }
  let!(:tag)         { create_tag('MEI') }

  before(:each) do
    sign_in admin
    visit catalogue_path
  end

  context "#create" do
    scenario "new image with tags" do
      expect(page).not_to have_content 'Test 1'
      fill_in 'Name', with: 'Test Image Upload'
      fill_in 'Tags', with: 'Tag_1,Tag_2,Tag_3,'
      attach_file 'Picture', Rails.root + "spec/fixtures/image_1.png"
      click_button 'Save Image'
      expect(page).to have_content 'Image successfully saved.'
    end
  end

  context "#view" do
    before(:each) do
      fill_in 'Name', with: 'Test Image Upload'
      fill_in 'Tags', with: 'Tag_1,Tag_2,Tag_3,'
      attach_file 'Picture', Rails.root + "spec/fixtures/image_1.png"
      click_button 'Save Image'
    end

    scenario "images with associated tags" do
      fill_in 'Filter tags', with: 'Tag_1'
      click_button 'Filter'
      expect(page).to have_content 'Test Image Upload'
      expect(page).to have_content 'Tag_1'
      expect(page).to have_content 'Tag_2'
      expect(page).to have_content 'Tag_3'
      expect(page).not_to have_content 'Test 1'
      expect(page).not_to have_content 'MEI'
    end
  end
end
