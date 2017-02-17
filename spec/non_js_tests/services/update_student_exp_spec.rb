describe UpdateStudentExpService do
  let!(:student) { create_student }
  let!(:course) { create_course  }
  let!(:unit)   { create_unit course }
  let!(:topic)  { create_topic unit }
  let!(:topic_2){ create_topic unit, 2 }
  let!(:lesson) { create_lesson topic, 1, 'Published' }
  let!(:lesson_2) { create_lesson topic, 2, 'Published' }
  let!(:lesson_3) { create_lesson topic, 3, 'Published' }
  let!(:question) { create_question(1, lesson) }
  let!(:lesson_exp) { create_student_lesson_exp(student, lesson, 0) }
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

  let!(:lesson_params) { { lesson_exp: lesson_exp, topic_exp: topic_exp,
                           correctness: 1, question: question,
                           topic_question: false } }

  let!(:lesson_params_2) { { lesson_exp: lesson_exp, topic_exp: topic_exp,
                           correctness: 0.5, question: question,
                           topic_question: false } }

  let!(:topic_params) { { lesson_exp: lesson_exp, topic_exp: topic_exp,
                           correctness: 1, question: question,
                           topic_question: true } }

  let!(:topic_params_2) { { lesson_exp: lesson_exp, topic_exp: topic_exp,
                           correctness: 0.5, question: question,
                           topic_question: true } }

  subject(:service) { described_class.new(lesson_params) }
  let!(:service_lesson_exp) { described_class.new(lesson_params_2) }
  let!(:service_topic_exp) { described_class.new(topic_params) }
  let!(:service_topic_exp_2) { described_class.new(topic_params_2) }

  context '#calculate_lesson_exp' do
    it "pass_exp 100 question exp 110 returns 100" do
      allow(lesson_exp).to receive(:streak_mtp).and_return(1.1)
      expect(subject.calculate_lesson_exp).to eq 100
    end

    it "pass_exp 100 user_lesson_exp 100 question exp 100 returns 0" do
      allow(lesson_exp).to receive(:exp).and_return(100)
      expect(subject.calculate_lesson_exp).to eq 0
    end

    it "pass_exp 100 question exp 50 returns 50" do
      expect(service_lesson_exp.calculate_lesson_exp).to eq 50
    end

    it "pass_exp 100 user_lesson_exp 60 question exp 50 returns 40" do
      allow(lesson_exp).to receive(:exp).and_return(60)
      expect(service_lesson_exp.calculate_lesson_exp).to eq 40
    end
  end

  context '#calculate_topic_exp' do
    it "reward_mtp 0 question exp 100 returns 100" do
      allow(topic_exp).to receive(:reward_mtp).and_return(1)
      expect(service_topic_exp.calculate_topic_exp).to eq 100
    end

    it "reward_mtp 30% question exp 100 returns 130" do
      allow(topic_exp).to receive(:reward_mtp).and_return(1)
      expect(service_topic_exp.calculate_topic_exp).to eq 100
    end

    it "pass_exp -30% question exp 100 returns 70" do
      allow(topic_exp).to receive(:reward_mtp).and_return(0.7)
      expect(service_topic_exp.calculate_topic_exp).to eq 70
    end
  end

  context '#update_lesson_exp' do
    it "updates lesson exp by 100" do
      expect { subject.update_lesson_exp(update_exp:100) }.to change { lesson_exp.exp }.by(100)
    end

    it "updates lesson exp by 50 if correctness 0.5" do
      expect { subject.update_lesson_exp(update_exp:50) }.to change { lesson_exp.exp }.by(50)
    end

    it "does not update lesson exp if topic_question? true" do
      expect { service_topic_exp.update_lesson_exp(update_exp:100) }.to change { lesson_exp.exp }.by(0)
    end

    it "does not update if correctness 0" do
      allow(subject).to receive(:correctness).and_return(0)
      expect { subject.update_lesson_exp(update_exp:100) }.to change { lesson_exp.exp }.by(0)
    end
  end

  context '#update_topic_exp' do
    it "updates topic exp by 100" do
      expect { service_topic_exp.update_topic_exp(update_exp:100) }.to change { topic_exp.exp }.by(100)
    end

    it "update topic exp by 50 if correctness 0.5" do
      expect { service_topic_exp.update_topic_exp(update_exp:50) }.to change { topic_exp.exp }.by(50)
    end

    it "does not update if correctness 0" do
      allow(service_topic_exp).to receive(:correctness).and_return(0)
      expect { service_topic_exp.update_topic_exp(update_exp:100) }.to change { topic_exp.exp }.by(0)
    end
  end

  context '#update_user_experience' do
    it "update lesson && topic exp by 50" do
      allow(subject).to receive(:correctness).and_return(0.5)
      expect { subject.update_user_experience }.to change { lesson_exp.exp }.by(50)
      expect { subject.update_user_experience }.to change { topic_exp.exp }.by(50)
    end

    it "update only topic exp by 100" do
      expect { service_topic_exp.update_user_experience }.to change { topic_exp.exp }.by 100
      expect { service_topic_exp.update_user_experience }.to change { lesson_exp.exp }.by 0
    end

    it "update neither topic by 0" do
      allow(subject).to receive(:correctness).and_return(0)
      expect { subject.update_user_experience }.to change { lesson_exp.exp }.by(0)
      expect { subject.update_user_experience }.to change { topic_exp.exp }.by(0)
    end
  end
end
