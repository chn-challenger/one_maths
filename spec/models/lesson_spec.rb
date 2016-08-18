require 'rails_helper'
require 'general_helpers'

describe Lesson, type: :model do
  describe '#random' do
    context 'there are questions to select from' do
      let!(:maker){create_maker}
      let!(:course){create_course(maker)}
      let!(:unit){create_unit(course,maker)}
      let!(:topic){create_topic(unit,maker)}
      let!(:lesson){create_lesson(topic,maker)}
      let!(:question_1){create_question(maker,1)}
      let!(:question_2){create_question(maker,2)}

      it 'randomly selects question 1' do
        lesson.questions = [question_1,question_2]
        lesson.save
        srand(100)
        random_question = lesson.random
        expect(random_question.question_text).to eq "question text 1"
        expect(random_question.solution).to eq "solution 1"
      end

      it 'randomly selects question 2' do
        srand(101)
        lesson.questions = [question_1,question_2]
        lesson.save
        random_question = lesson.random
        expect(random_question.question_text).to eq "question text 2"
        expect(random_question.solution).to eq "solution 2"
      end
    end

    context 'there are no questions to select from' do
      let!(:maker){create_maker}
      let!(:course){create_course(maker)}
      let!(:unit){create_unit(course,maker)}
      let!(:topic){create_topic(unit,maker)}
      let!(:lesson){create_lesson(topic,maker)}

      it 'randomly selects question 1' do
        random_question = lesson.random
        expect(random_question).to eq nil
      end
    end
  end
end
