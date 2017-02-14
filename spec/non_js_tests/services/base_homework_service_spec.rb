describe BaseHomeworkService do
  let!(:student) { create_student }
  let!(:course) { create_course  }
  let!(:unit)   { create_unit course }
  let!(:topic)  { create_topic unit }
  let!(:topic_2){ create_topic_2 unit }
  let!(:lesson) { create_lesson topic, 1, 'Published' }
  let!(:question) { create_question(1, lesson) }
  let!(:lesson_exp) { create_student_lesson_exp(student,lesson, 0) }
  let!(:topic_exp) { create_student_topic_exp(student, topic, 0) }
  subject(:homework_base) { described_class.new }


  context '#calculate_target_exp' do
    it "when lvl 2 and target_exp = 200 returns 300" do
      opts = {level: 2, target_exp: 200}
      expect(subject.calculate_target_exp(topic, student, opts)).to eq 300
    end

    it "when lvl 1 and target_exp = 30 returns 30" do
      opts = {level: 1, target_exp: 30}
      expect(subject.calculate_target_exp(topic, student, opts)).to eq 30
    end

    it "when lvl 4 and target_exp = 100 returns 800" do
      opts = {level: 4, target_exp: 100}
      expect(subject.calculate_target_exp(topic, student, opts)).to eq 800
    end
  end

  context '#fetch_topic_exp' do
    it "retrieves existing student topic exp record" do
      student_topic_exp = subject.send(:fetch_topic_exp, student, topic)
      expect(student_topic_exp).to eq topic_exp
    end

    it "creates student topic exp if no record exists" do
      student_topic_exp = subject.send(:fetch_topic_exp, student, topic_2)
      expect(student_topic_exp).not_to eq topic_exp
      expect(student_topic_exp).to be_a StudentTopicExp
    end
  end

end
