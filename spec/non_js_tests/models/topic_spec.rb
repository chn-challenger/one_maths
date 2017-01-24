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
    let!(:question_8) { create_question_with_lvl(8, 2) }
    let!(:choice_15){create_choice(question_8,15,false)}
    let!(:choice_16){create_choice(question_8,16,true)}

    let!(:question_9) { create_question_with_lvl(9, 3) }
    let!(:choice_17){create_choice(question_9,17,false)}
    let!(:choice_18){create_choice(question_9,18,true)}

    let!(:question_10) { create_question_with_lvl(10, 4) }
    let!(:choice_19){create_choice(question_10,19,false)}
    let!(:choice_20){create_choice(question_10,20,true)}


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

    it 'question lvl 2 passed it returns lvl 3' do
      questions = [question_9]
      expect(topic.confirm_level(2, questions)).to eq 3
    end

    it "question lvl 2 passed it returns lvl 2" do
      questions = [question_8, question_9]
      expect(topic.confirm_level(2, questions)).to eq 2
    end

    it 'question lvl 2 passed it returns lvl 1' do
      questions = [question_1, question_9]
      expect(topic.confirm_level(2, questions)).to eq 1
    end

    it 'question lvl 1 passed it returns lvl 2' do
      questions = [question_8, question_9]
      expect(topic.confirm_level(1, questions)).to eq 2
    end

    it 'question lvl 1 passed it returns lvl 3' do
      questions = [question_9]
      expect(topic.confirm_level(1, questions)).to eq 3
    end

    it 'question lvl 3 passed it returns lvl 2' do
      questions = [question_1, question_8]
      expect(topic.confirm_level(3, questions)).to eq 2
    end

    it 'question lvl 3 passed it returns lvl 1' do
      questions = [question_1]
      expect(topic.confirm_level(3, questions)).to eq 1
    end

  end
end
