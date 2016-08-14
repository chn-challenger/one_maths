require 'rails_helper'
require 'general_helpers'

feature 'choices' do
  context 'A question with no choices' do
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:unit){create_unit(course,maker)}
    let!(:topic){create_topic(unit,maker)}
    let!(:lesson){create_lesson(topic,maker)}
    let!(:question){create_question(lesson,maker)}

    scenario 'should display a prompt to add a multiple choice' do
      sign_in_maker
      visit "/units/#{unit.id}"
      expect(page).to have_link 'Add a multiple choice to question'
    end
  end

end
