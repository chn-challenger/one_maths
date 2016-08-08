require 'rails_helper'
require 'general_helpers'

describe Lesson, type: :model do
  describe '#random_question' do
    context 'there are questions to select from' do
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
        random_question = lesson.random_question
        expect(random_question[:question]).to eq "Solve $2+x=5$"
        expect(random_question[:solution]).to eq "$x = 3$"
      end

      it 'randomly selects question 2' do
        srand(101)
        random_question = lesson.random_question
        expect(random_question[:question]).to eq "Solve $x-3=8$"
        expect(random_question[:solution]).to eq "$x = 11$"
      end
    end

    context 'there are no questions to select from' do
      let!(:maker){create_maker}
      let!(:course){create_course(maker)}
      let!(:unit){create_unit(course,maker)}
      let!(:topic){create_topic(unit,maker)}
      let!(:lesson){create_lesson(topic,maker)}

      it 'randomly selects question 1' do
        random_question = lesson.random_question
        expect(random_question[:question]).to eq ""
        expect(random_question[:solution]).to eq ""
      end
    end
  end
end
