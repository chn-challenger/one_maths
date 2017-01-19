describe TopicsHelper, type: :helper do
  let!(:topic_helper) { Class.new { include TopicsHelper }.new }
  let!(:course) { create_course  }
  let!(:unit)   { create_unit course }
  let!(:topic)  { create_topic unit }
  let!(:lesson) { create_lesson topic, 1, 'Published' }
  let!(:lesson_2) { create_lesson topic, 2, 'Published' }
  let!(:student){ create_student }
  let!(:question_1) { create_question(1, lesson) }
  let!(:question_25){create_question_with_order(25,"b1")}
  let!(:answer_25){create_answers(question_25,[['a=','+5,-8,7.1,6.21']])}
  let!(:question_26){create_question_with_order(26,"b1")}
  let!(:answer_26){create_answers(question_26,[['a=','+5,-8,6.21'],['b=','7'],['c=','4']])}

  describe '#topic_unlocked' do
    it "returns true" do
      create_student_lesson_exp(student,lesson,1000)
      create_student_lesson_exp(student,lesson_2,1000)
      expect(topic_helper.topic_unlocked?(topic.lessons, student)).to eq true
    end

    it "returns false" do
      create_student_lesson_exp(student,lesson,99)
      create_student_lesson_exp(student,lesson_2,1000)
      expect(topic_helper.topic_unlocked?(topic.lessons, student)).to eq false
    end
  end
end
