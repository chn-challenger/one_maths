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

  context "#exam_questions" do
    before(:each) do
      fill_in 'Tags', with: 'Tag_1,Tag_2,Tag_3,'
      attach_file 'Picture', Rails.root + "spec/fixtures/image_1.png"
      click_button 'Save Question Image'
      fill_in 'Tags', with: 'Tag_1,Tag_4,Tag_5,'
      attach_file 'Picture', Rails.root + "spec/fixtures/image_1.png"
      click_button 'Save Question Image'
    end

    scenario "enter one correct tags and get two images" do
      visit exam_questions_path
      check("show-tags-check")
      fill_in 'Filter tags', with: 'Tag_1'
      click_button 'Filter'
      expect(page).to have_content 'Tag_1'
      expect(page).to have_content 'Tag_2'
      expect(page).to have_content 'Tag_4'
      expect(page).not_to have_content 'Test 1'
      expect(page).not_to have_content 'MEI'
    end

    scenario "enter two correct tags and get an image" do
      visit exam_questions_path
      check("show-tags-check")
      fill_in 'Filter tags', with: 'Tag_1,Tag_2'
      click_button 'Filter'
      expect(page).to have_content 'Tag_1'
      expect(page).to have_content 'Tag_2'
      expect(page).to have_content 'Tag_3'
      expect(page).not_to have_content 'Test 1'
      expect(page).not_to have_content 'MEI'
    end

    scenario "no tags entered get flash message" do
      visit exam_questions_path
      check("show-tags-check")
      fill_in 'Filter tags', with: ''
      click_button 'Filter'
      expect(page).not_to have_content 'Tag_1'
      expect(page).to have_content 'You did not select any filter tags'
    end

    scenario "wrong tags entered nothing returned" do
      visit exam_questions_path
      check("show-tags-check")
      fill_in 'Filter tags', with: 'wrong'
      click_button 'Filter'
      expect(page).not_to have_content 'Tag_1'
      expect(page).not_to have_content 'You did not select any filter tags'
    end

    scenario "one wrong and one correct tag entered nothing returned" do
      visit exam_questions_path
      check("show-tags-check")
      fill_in 'Filter tags', with: 'Tag_1,Wrong'
      click_button 'Filter'
      expect(page).not_to have_content 'Tag_1'
      expect(page).not_to have_content 'You did not select any filter tags'
    end
  end

  context "#edit" do
    before(:each) do
      fill_in 'Tags', with: 'Tag_1,Tag_2,Tag_3,'
      attach_file 'Picture', Rails.root + "spec/fixtures/image_1.png"
      click_button 'Save Question Image'
      visit "/edit_exam_question/2"
    end

    scenario "delete tag from image" do
      expect(page).to have_content "Tag_1"
      expect(page).to have_content "Tag_2"
      expect(page).to have_content "Tag_3"
      click_link 'del-tag-2'
      expect(current_path).to eq "/edit_exam_question/2"
      expect(page).not_to have_content "Tag_1"
      expect(page).to have_content "Tag_2"
      expect(page).to have_content "Tag_3"
    end

    scenario "add tag to image" do
      expect(page).not_to have_content "Tag_4"
      fill_in 'Tags', with: "Tag_4"
      click_button 'Add tags'
      expect(current_path).to eq "/edit_exam_question/2"
      expect(page).to have_content "Tag_4"
    end

    scenario "if tag already exists its not dublicated" do
      expect(page).to have_content("Tag_1", count: 1)
      fill_in 'Tags', with: "Tag_1"
      click_button 'Add tags'
      expect(page).to have_content("Tag_1", count: 1)
    end
  end
end
