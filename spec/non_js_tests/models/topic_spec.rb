require 'rails_helper'


describe Topic, type: :model do
  describe '#random_question' do
    let!(:course) { create_course  }
    let!(:unit)   { create_unit course }
    let!(:topic)  { create_topic unit }
    let!(:lesson) { create_lesson topic, 1, 'Published' }
    let!(:admin)  { create_admin   }
    let!(:student){ create_student }
    let!(:question_1){create_question(1)}
    let!(:question_2){create_question(2)}
    let!(:question_3){create_question(3)}

    xit 'picks a question from the remaining list of unanswered questions' do
      topic.questions << question_1
      topic.questions << question_2
      topic.questions << question_3
      topic.save
      AnsweredQuestion.create(user_id:student.id, question_id: question_1.id, correct: false)
      srand(100)
      expect(topic.random_question(student)).to eq question_2
      srand(101)
      expect(topic.random_question(student)).to eq question_3
    end
  end
end
