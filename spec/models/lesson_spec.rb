require 'rails_helper'
require 'general_helpers'

describe Lesson, type: :model do
  describe '#random_question' do
    let!(:course) { create_course  }
    let!(:unit)   { create_unit course }
    let!(:topic)  { create_topic unit }
    let!(:lesson) { create_lesson topic }
    let!(:admin)  { create_admin   }
    let!(:student){ create_student }
    let!(:question_1){create_question(1)}
    let!(:choice_1){create_choice(question_1,1,false)}
    let!(:choice_2){create_choice(question_1,2,true)}
    let!(:question_2){create_question(2)}
    let!(:choice_3){create_choice(question_2,3,false)}
    let!(:choice_4){create_choice(question_2,4,true)}
    let!(:question_3){create_question(3)}
    let!(:choice_5){create_choice(question_3,5,false)}
    let!(:choice_6){create_choice(question_3,6,true)}

    it 'picks a question from the remaining list of unanswered questions' do
      lesson.questions << question_1
      lesson.questions << question_2
      lesson.save
      aq = AnsweredQuestion.create(user_id:student.id, question_id: question_1.id, correct: false)
      # puts ""
      # puts '%%%%%%%%%%%%% ANSWERED QUESTION %%%%%%%%%%%'
      # p aq
      # puts '%%%%%%%%%%%%% ANSWERED QUESTION %%%%%%%%%%%'
      # puts ""
      srand(100)
      expect(lesson.random_question(student)).to eq question_2
    end
  end
end
