require 'rails_helper'
require 'general_helpers'

describe Question, type: :model do
  describe '#unused' do
    let!(:course)    { create_course  }
    let!(:unit)      { create_unit course }
    let!(:topic)     { create_topic unit }
    let!(:lesson)    { create_lesson topic, 1, 'Published' }
    let!(:admin)     { create_admin   }
    let!(:student)   { create_student }
    let!(:student_2) {create_student_2}
    let!(:question_1){create_question(1)}
    let!(:question_2){create_question(2)}
    let!(:question_3){create_question(3)}
    let!(:question_4){create_question(4)}
    let!(:question_5){create_question(5)}
    let!(:question_6){create_question(6, lesson)}
    let!(:question_7){create_question(7, lesson)}
    let!(:question_8){create_question(8, lesson)}

    it 'returns an array of questions not inside any lesson' do
      lesson.questions << question_1
      lesson.questions << question_2
      lesson.save
      expect(Question.unused).to eq [question_3,question_4,question_5]
    end

    describe "#destroy" do
      let!(:ansq_1) { create_answered_question_manager(student, question_6, lesson) }
      let!(:ansq_2) { create_answered_question_manager(student_2, question_6, lesson) }
      let!(:sle)    { create_student_lesson_exp(student, lesson, 100) }
      let!(:ste)    { create_student_topic_exp(student, topic, 100) }

      it 'delete question record' do
        expect { question_6.destroy }.to change { Question.count }.by(-1)
      end

      it 'destroys all dependents' do
        expect { question_6.destroy }.to change { AnsweredQuestion.count }.by(-2)
      end

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
