require 'rails_helper'
require 'general_helpers'

describe Question, type: :model do
  describe '#unused' do
    let!(:course) { create_course  }
    let!(:unit)   { create_unit course }
    let!(:topic)  { create_topic unit }
    let!(:lesson) { create_lesson topic }
    let!(:admin)  { create_admin   }
    let!(:student){ create_student }
    let!(:question_1){create_question(1)}
    let!(:question_2){create_question(2)}
    let!(:question_3){create_question(3)}
    let!(:question_4){create_question(4)}
    let!(:question_5){create_question(5)}
    # let!(:question_6){create_question(6)}
    # let!(:question_7){create_question(7)}
    # let!(:question_8){create_question(8)}


    it 'returns an array of questions not inside any lesson' do
      lesson.questions << question_1
      lesson.questions << question_2
      lesson.save
      expect(Question.unused).to eq [question_3,question_4,question_5]
    end

    it 'returns an array of questions not inside any topic' do
      topic.questions << question_1
      topic.questions << question_3
      topic.save
      expect(Question.unused).to eq [question_2,question_4,question_5]
    end

    it 'returns an array of questions not inside any topic or lesson' do
      topic.questions << question_1
      topic.questions << question_3
      topic.save
      lesson.questions << question_1
      lesson.questions << question_2
      lesson.save
      expect(Question.unused).to eq [question_4,question_5]
    end
  end
end
