describe UpdateHomeworkService do
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
  let(:lesson_homework) { create_lesson_homework(student, lesson) }
  let(:lesson_homework_2) { create_lesson_homework(student, lesson_2) }
  let!(:topic_homework) { create_topic_homework(student, topic, 30) }

  let!(:params) { {lessons: {"#{lesson.id}"=>"70",
                  "#{lesson_2.id}"=>"65"},
                  topics:
                    {"#{topic.id}"=>{level:"3",target_exp:"100"}}
                  }
    }
  subject(:homework_service) { UpdateHomeworkService.new(params: params, student: student) }

  context '#update_lesson_homework' do
    it "returns false if params do not have lessons" do
      local_params = {topics: {"10"=>{level: "4", target_exp: "262"},
                              "15"=>{level: "1", target_exp: "414.5"}}}

      homework_updater = UpdateHomeworkService.new(params: local_params, student: student)
      expect(homework_updater.update_lesson_homework).to eq false
    end

    it "update lesson homework" do
      expect(lesson_homework.target_exp).to eq 20
      expect(lesson_homework_2.target_exp).to eq 20
      subject.update_lesson_homework
      expect(lesson_homework.reload.target_exp).to eq 70
      expect(lesson_homework_2.reload.target_exp).to eq 65
    end
  end

  context '#update_topic_homework' do
    it "returns false if params do not have topics" do
      local_params = {lessons: {"10"=>{level: "4", target_exp: "262"},
                              "15"=>{level: "1", target_exp: "50"}}}

      homework_updater = UpdateHomeworkService.new(params: local_params, student: student)
      expect(homework_updater.update_topic_homework).to be false
    end

    it "update topic homework" do
      expect(topic_homework.target_exp).to eq 30
      subject.update_topic_homework
      expect(topic_homework.reload.target_exp).to eq 400
    end
  end

  context '#execute' do
    it "calls update lesson/topic homework methods" do
      expect(subject).to receive(:update_lesson_homework)
      expect(subject).to receive(:update_topic_homework)
      subject.execute
    end
  end
end
