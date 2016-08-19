require 'rails_helper'
require 'general_helpers'

feature 'lessons' do
  context 'submitting an answer' do
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:unit){create_unit(course,maker)}
    let!(:topic){create_topic(unit,maker)}
    let!(:lesson){create_lesson(topic,maker)}
    let!(:question_1){create_question(maker,1)}
    let!(:question_2){create_question(maker,2)}

    # it 'test will fail when js is turned on', js: true do
    it 'test succeeds as expected' do
      lesson.questions = [question_1,question_2]
      lesson.save
      srand(100) #the view calls lesson.random to get a random question
      visit "/units/#{unit.id}"
      expect(page).to have_content 'question text 1'
      expect(page).to have_link 'Show solution'
    end
  end

end
