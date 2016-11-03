feature "Catalogue" do
  let!(:admin)       { create_admin }
  let!(:super_admin) { create_super_admin }
  let!(:image)       { create_image('Test 1') }
  let!(:tag)         { create_tag('MEI') }

  before(:each) do
    sign_in admin
    visit new_catalogue_path
  end

  context "#create" do
    scenario "new image with tags" do
      expect(page).not_to have_content 'Test 1'
      fill_in 'Tags', with: 'Tag_1,Tag_2,Tag_3,'
      attach_file 'Picture', Rails.root + "spec/fixtures/image_1.png"
      click_button 'Save Question Image'
      expect(page).to have_content 'Image successfully saved.'
    end

    scenario "new image with tags from URL" do
      fill_in 'Tags', with: 'Tag_1,Tag_2,Tag_3,'
      fill_in 'Image url', with: 'http://www.clipular.com/c/5546281804234752.png?k=JX_EsT_7hL6KTbcwIpZXW_E4ZPo'
      click_button 'Save Question Image'
      expect(page).to have_content 'Image successfully saved.'
    end
  end

  context "#view" do
    before(:each) do
      fill_in 'Tags', with: 'Tag_1,Tag_2,Tag_3,'
      attach_file 'Picture', Rails.root + "spec/fixtures/image_1.png"
      click_button 'Save Question Image'
    end

    scenario "images with associated tags" do
      visit exam_questions_path
      check("show-tags-check")
      fill_in 'Filter tags', with: 'Tag_1'
      click_button 'Filter'
      expect(page).to have_content 'Tag_1'
      expect(page).to have_content 'Tag_2'
      expect(page).to have_content 'Tag_3'
      expect(page).not_to have_content 'Test 1'
      expect(page).not_to have_content 'MEI'
    end
  end
end
