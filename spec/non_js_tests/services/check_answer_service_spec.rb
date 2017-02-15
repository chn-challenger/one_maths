describe CheckAnswerService do
  let!(:student) { create_student }
  let!(:course) { create_course  }
  let!(:unit)   { create_unit course }
  let!(:topic)  { create_topic unit }
  let!(:topic_2){ create_topic_2 unit }
  let!(:lesson) { create_lesson topic, 1, 'Published' }
  let!(:lesson_2) { create_lesson topic, 2, 'Published' }
  let!(:question) { create_question(1, lesson) }
  let!(:lesson_exp) { create_student_lesson_exp(student,lesson, 0) }
  let!(:lesson_exp_2) { create_student_lesson_exp(student,lesson_2, 0) }
  let!(:topic_exp) { create_student_topic_exp(student, topic, 0) }
  let!(:question_1) { create_question(1, lesson) }
  let!(:choice_1) { create_choice(question_1, 1, false) }
  let!(:choice_2) { create_choice(question_1, 2, true) }
  let!(:question_2) { create_question(2, lesson) }
  let!(:choice_3) { create_choice(question_2, 3, false) }
  let!(:choice_4) { create_choice(question_2, 4, true) }
  let!(:question_3) { create_question(3) }
  let!(:choice_5) { create_choice(question_3, 5, false) }
  let!(:choice_6) { create_choice(question_3, 6, true) }
  let!(:question_4) { create_question(4, lesson) }
  let!(:answer_4) { create_answer(question_4, 4) }
  let!(:question_5) { create_question(5, lesson)}
  let!(:answer_5) { create_answer(question_5, 5) }
  let!(:answer_5_2) { create_answer(question_5, 5) }

  let!(:lesson_params) { {"choice"=>"#{choice_1.id}", "question_id"=>"#{question_1.id}",
                          "lesson_id"=>"#{lesson.id}", "id"=>"#{question_1.id}"} }
  let!(:lesson_params_2) { {"choice"=>"#{choice_2.id}", "question_id"=>"#{question_1.id}",
                          "lesson_id"=>"#{lesson.id}", "id"=>"#{question_1.id}"} }

  let!(:lesson_params_3) { {"js_answers"=>{"0"=>["x55", "55"],
                            "1"=>["x5", "55"]}, "question_id"=>"#{question_5.id}",
                            "lesson_id"=>"#{lesson.id}", "id"=>"#{question_5.id}"}
                          }
  let!(:topic_params)    { {"js_answers"=>{"0"=>["x4", "44"]},
                            "question_id"=>"#{question_4.id}", "topic_id"=>"#{topic.id}",
                            "id"=>"#{question_4.id}"}
                          }
  let!(:topic_params_2)  { {"choice"=>"#{choice_6.id}", "question_id"=>"#{question_3.id}",
                            "topic_id"=>"#{topic.id}", "id"=>"#{question_3.id}"} }

  subject(:check_answer_lesson_choice) { described_class.new(params: lesson_params, user: student) }
  let!(:check_answer_lesson_answer) { described_class.new(params: lesson_params_3, user: student) }

  context '#set_question' do
    it "sets question from params" do
      subject.set_question
      expect(subject.question).to eq question_1
    end
  end

  context '#set_answer_params' do
    it "standardises_answer_params" do
      answer_hash = {"x55"=>"55", "x5"=>"55"}
      check_answer_lesson_answer.set_answer_params
      expect(check_answer_lesson_answer.answer_params).to eq answer_hash
    end
  end

  context '#set_correct_and_correctness' do
    it "correct false and correctness 0" do
      subject.set_question
      subject.set_answer_params
      subject.set_correct_and_correctness
      expect(subject.correct).to be false
      expect(subject.correctness).to eq 0
    end
  end
end
