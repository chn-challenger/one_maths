describe CheckAnswerService do
  let!(:student) { create_student }
  let!(:course) { create_course  }
  let!(:unit)   { create_unit course }
  let!(:topic)  { create_topic unit }
  let!(:topic_2){ create_topic unit, 2 }
  let!(:lesson) { create_lesson topic, 1, 'Published' }
  let!(:lesson_2) { create_lesson topic, 2, 'Published' }
  let!(:lesson_3) { create_lesson topic, 3, 'Published' }
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
  let!(:service_topic_answer) { described_class.new(params: topic_params, user: student) }

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

  context '#fetch_student_exp' do
    context 'arguments as hash' do
      it "fetches student lesson experience" do
        lesson_hash = { lesson_id: lesson.id }
        expect(subject.fetch_student_exp(record_hash: lesson_hash)).to eq lesson_exp
      end

      it "fetches student topic experience" do
        topic_hash = { topic_id: topic.id }
        expect(subject.fetch_student_exp(record_hash: topic_hash)).to eq topic_exp
      end

      it "create new lesson experience" do
        lesson_hash = { lesson_id: lesson_3.id }
        expect { subject.fetch_student_exp(record_hash: lesson_hash) }.to change { StudentLessonExp.count }.by(1)
      end

      it "create new topic experience" do
        topic_hash = { topic_id: topic_2.id }
        expect { subject.fetch_student_exp(record_hash: topic_hash) }.to change { StudentTopicExp.count }.by(1)
      end
    end

    context 'arguments as record' do
      it "fetch student lesson experience" do
        expect(subject.fetch_student_exp(record: lesson)).to eq lesson_exp
      end

      it "fetch student topic experience" do
        expect(subject.fetch_student_exp(record: topic)).to eq topic_exp
      end

      it "creates new lesson experience" do
        expect { subject.fetch_student_exp(record: lesson_3) }.to change { StudentLessonExp.count }.by(1)
      end

      it "creates new topic experience" do
        expect { subject.fetch_student_exp(record: topic_2) }.to change { StudentTopicExp.count }.by(1)
      end
    end
  end

  context '#load_student_exp' do
    it "loads topic and lesson exp for lesson question" do
      exp_hash = { topic_exp: topic_exp, lesson_exp: lesson_exp }
      expect(subject.load_student_exp).to eq exp_hash
    end

    it "loads topic exp only for topic question" do
      exp_hash = { topic_exp: topic_exp, lesson_exp: nil}
      expect(service_topic_answer.load_student_exp).to eq exp_hash
    end
  end
end
