require 'rails_helper'
require 'general_helpers'

feature 'topics' do
  context 'adding a topic' do
    let!(:admin)  { create_admin   }
    let!(:student){ create_student }
    let!(:course) { create_course  }
    let!(:unit)   { create_unit course }

    scenario 'an admin can add a topic' do
      sign_in admin
      visit "/units/#{ unit.id }"
      click_link 'Add a new chapter'
      fill_in 'Name', with: 'Indices'
      fill_in 'Description', with: 'Powers'
      click_button 'Create Topic'
      expect(page).to have_content 'Indices'
      expect(page).to have_content 'Powers'
      expect(current_path).to eq "/units/#{ unit.id }"
    end

    scenario 'cannot add a topic if not signed in' do
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Add a new chapter'
    end

    scenario 'cannot visit the add topic page unless signed in' do
      visit "/units/#{ unit.id }/topics/new"
      expect(current_path).to eq "/units/#{ unit.id }"
      expect(page).to have_content 'You do not have permission to add a topic'
    end

    scenario 'cannot add a topic if signed in as a student' do
      sign_in student
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Add a new chapter'
    end

    scenario 'cannot visit the add topic page if signed in as a student' do
      sign_in student
      visit "/units/#{ unit.id }/topics/new"
      expect(current_path).to eq "/units/#{ unit.id }"
      expect(page).to have_content 'You do not have permission to add a topic'
    end
  end

  context 'updating topics' do
    let!(:admin)  { create_admin   }
    let!(:student){ create_student }
    let!(:course) { create_course  }
    let!(:unit)   { create_unit course }
    let!(:topic)  { create_topic unit }

    scenario 'an admin can edit a topic' do
      sign_in admin
      visit "/units/#{ unit.id }"
      click_link 'Edit chapter'
      fill_in 'Name', with: 'New topic'
      fill_in 'Description', with: 'New topic desc'
      click_button 'Update Topic'
      expect(page).to have_content 'New topic'
      expect(page).to have_content 'New topic desc'
      expect(current_path).to eq "/units/#{ unit.id }"
    end

    scenario 'when not signed in cannot see edit link' do
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Edit chapter'
    end

    scenario 'when not signed in cannot visit edit page' do
      visit "/topics/#{ topic.id }/edit"
      expect(page).to have_content 'You do not have permission to edit a topic'
      expect(current_path).to eq "/units/#{ unit.id }"
    end

    scenario 'a student cannot see edit link' do
      sign_in student
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Edit'
    end

    scenario 'a student cannot visit edit page' do
      sign_in student
      visit "/topics/#{ topic.id }/edit"
      expect(page).to have_content 'You do not have permission to edit a topic'
      expect(current_path).to eq "/units/#{ unit.id }"
    end
  end

  context 'deleting topics' do
    let!(:admin)  { create_admin   }
    let!(:student){ create_student }
    let!(:course) { create_course  }
    let!(:unit)   { create_unit course }
    let!(:topic)  { create_topic unit }

    scenario 'an admin can delete a topic' do
      sign_in admin
      visit "/units/#{ unit.id }"
      click_link 'Delete chapter'
      expect(page).not_to have_content topic.name
      expect(page).not_to have_content topic.description
      expect(page).to have_content 'Topic deleted successfully'
      expect(current_path).to eq "/units/#{ unit.id }"
    end

    scenario 'an admin can send delete request' do
      sign_in admin
      page.driver.submit :delete, "/topics/#{ topic.id }",{}
      expect(page).to have_content 'Topic deleted successfully'
      expect(current_path).to eq "/units/#{ unit.id }"
    end

    scenario 'when not signed in cannot see delete link' do
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Delete chapter'
    end

    scenario 'when not signed in cannot send delete request' do
      page.driver.submit :delete, "/topics/#{ topic.id }",{}
      expect(page).to have_content 'You do not have permission to delete a topic'
      expect(current_path).to eq "/units/#{ unit.id }"
    end

    scenario 'a student cannot see delete link' do
      sign_in student
      visit "/units/#{ unit.id }"
      expect(page).not_to have_link 'Delete chapter'
    end

    scenario 'a student cannot send a delete request' do
      sign_in student
      page.driver.submit :delete, "/topics/#{ topic.id }",{}
      expect(page).to have_content 'You do not have permission to delete a topic'
      expect(current_path).to eq "/units/#{ unit.id }"
    end
  end
end


# feature 'topics' do
#   context 'A course unit with no topics' do
#     let!(:maker){create_maker}
#     let!(:course){create_course(maker)}
#     let!(:core_1){create_unit(course,maker)}
#
#     scenario 'should display a prompt to add a topic' do
#       sign_in_maker
#       visit "/units/#{core_1.id}"
#       expect(page).to have_link 'Add a new chapter'
#     end
#   end
#
#   context 'topics have been added' do
#     let!(:maker){create_maker}
#     let!(:course){create_course(maker)}
#     let!(:unit){create_unit(course,maker)}
#     let!(:indices){create_topic(unit,maker)}
#
#     scenario 'display the added topics' do
#       visit "/units/#{unit.id}"
#       expect(page).to have_content 'Chapter 1 Indices'
#     end
#   end
#
#   context 'adding topics' do
#     let!(:maker){create_maker}
#     let!(:course){create_course(maker)}
#     let!(:unit){create_unit(course,maker)}
#
#     scenario 'when not logged in cannot add topic' do
#       visit "/units/#{unit.id}"
#       expect(page).not_to have_link "Add a new chapter"
#     end
#
#     scenario 'a maker adding a unit to his course' do
#       sign_in_maker
#       visit "/units/#{unit.id}"
#       click_link "Add a new chapter"
#       fill_in 'Name', with: 'Indices'
#       fill_in 'Description', with: 'blank'
#       click_button 'Create Topic'
#       expect(page).to have_content 'Indices'
#       expect(current_path).to eq "/units/#{unit.id}"
#     end
#
#     scenario 'a different maker cannot add a topic' do
#       sign_up_tester
#       visit "/units/#{unit.id}/topics/new"
#       expect(page).not_to have_link "Add a new chapter"
#       expect(page).to have_content 'You can only add topics to your own unit'
#       expect(current_path).to eq "/units/#{unit.id}"
#     end
#   end
#
#   context 'updating topics' do
#     let!(:maker){create_maker}
#     let!(:course){create_course(maker)}
#     let!(:unit){create_unit(course,maker)}
#     let!(:indices){create_topic(unit,maker)}
#
#     scenario 'a maker can update his own topics' do
#       sign_in_maker
#       visit "/units/#{unit.id}"
#       click_link 'Edit chapter'
#       fill_in 'Name', with: 'Algebra 1'
#       fill_in 'Description', with: 'basic equations'
#       click_button 'Update Topic'
#       expect(page).to have_content 'Algebra 1'
#       expect(page).to have_content 'basic equations'
#       expect(current_path).to eq "/units/#{unit.id}"
#     end
#
#     scenario "a maker cannot edit someone else's topics" do
#       sign_up_tester
#       visit "/topics/#{indices.id}/edit"
#       expect(page).not_to have_link 'Edit chapter'
#       expect(page).to have_content 'You can only edit your own topics'
#       expect(current_path).to eq "/units/#{unit.id}"
#     end
#   end
#
#   context 'deleting units' do
#     let!(:maker){create_maker}
#     let!(:course){create_course(maker)}
#     let!(:unit){create_unit(course,maker)}
#     let!(:indices){create_topic(unit,maker)}
#
#     scenario 'a maker can delete their own topics' do
#       sign_in_maker
#       visit "/units/#{unit.id}"
#       click_link 'Delete chapter'
#       expect(page).not_to have_content "Indices"
#       expect(page).not_to have_content "blank"
#       expect(current_path).to eq "/units/#{unit.id}"
#     end
#
#     scenario "a maker cannot delete another maker's topics" do
#       sign_up_tester
#       visit "/units/#{unit.id}"
#       expect(page).not_to have_link 'Delete chapter'
#       page.driver.submit :delete, "/topics/#{indices.id}",{}
#       expect(page).to have_content 'Can only delete your own topics'
#     end
#   end
# end
