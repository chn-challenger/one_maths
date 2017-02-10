describe CreateHomeworkService do
  let!(:student) { create_student }
  let!(:course) { create_course  }
  let!(:unit)   { create_unit course }
  let!(:topic)  { create_topic unit }
  let!(:lesson) { create_lesson topic, 1, 'Published' }
  let!(:lesson_2) { create_lesson topic, 2, 'Published' }
  let!(:lesson_exp) { create_student_lesson_exp(student,lesson, 0) }
  let!(:lesson_exp_2) { create_student_lesson_exp(student,lesson_2, 0) }
  let!(:topic_exp) { create_student_topic_exp(student, topic, 0) }


  let!(:params) { {lessons: {"#{lesson.id}"=>"38",
                  "#{lesson_2.id}"=>"50"},
                  topics:
                    {"10"=>{level: "4", target_exp: "262"},
                    "15"=>{level: "1", target_exp: "414.5"}}
                  }
    }
  subject(:homework_service) { CreateHomeworkService.new(params: params, student: student) }

  context '#create_lesson_homework' do
    it "returns nil if params do not have lessons" do
      local_params = {topics: {"10"=>{level: "4", target_exp: "262"},
                              "15"=>{level: "1", target_exp: "414.5"}}}

      homework_creator = CreateHomeworkService.new(params: local_params, student: student)
      expect(homework_creator.create_lesson_homework).to eq nil
    end

    it "creates lesson homework" do
      subject.create_lesson_homework
      expect(student.homework.count).to eq 2
    end
  end

  context '#create_topic_homework' do
    it "returns nil if params do not have topics" do
      local_params = {lessons: {"10"=>{level: "4", target_exp: "262"},
                              "15"=>{level: "1", target_exp: "414.5"}}}

      homework_creator = CreateHomeworkService.new(params: local_params, student: student)
      expect(homework_creator.create_topic_homework).to eq nil
    end

    it "creates topic homework" do

    end
  end

  context '#calculate_topic_experience' do
    it "when lvl 2 and target_exp = 200 returns" do

    end
  end
end
