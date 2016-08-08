require 'rails_helper'
require 'general_helpers'

describe Lesson, type: :model do
  describe '#random_question' do
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:unit){create_unit(course,maker)}
    let!(:topic){create_topic(unit,maker)}
    let!(:lesson){create_lesson(topic,maker)}
    let!(:question1){create_question(lesson,maker)}
    let!(:question2){lesson.questions.create_with_maker({
      question_text:'Solve $x-3=8$',
      solution:'$x = 11$'},maker)}

    it 'randomly selects question 1' do
      srand(100)
      expect(lesson.random_question).to eq question1
    end

    it 'randomly selects question 2' do
      srand(101)
      expect(lesson.random_question).to eq question2
    end
  end
end
