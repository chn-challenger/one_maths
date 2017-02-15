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
  let!(:question_3) { create_question(3, lesson) }
  let!(:choice_5) { create_choice(question_3, 5, false) }
  let!(:choice_6) { create_choice(question_3, 6, true) }


  let!(:lesson_params) { {"choice"=>"180", "question_id"=>"47",
                          "lesson_id"=>"17", "id"=>"47"} }
  let!(:lesson_params_2) { {"js_answers"=>{"0"=>["When $y=0$, $x=$", "2"],
                            "1"=>["When $x=0$, $y=$", "5"]}, "question_id"=>"301",
                            "lesson_id"=>"29", "id"=>"301"}
                          }
  let!(:topic_params)    { {"js_answers"=>{"0"=>["$n=$", "23"]},
                            "question_id"=>"1289", "topic_id"=>"12",
                            "id"=>"1289"}
                          }
  let!(:topic_params_2)  { {"choice"=>"1560", "question_id"=>"1394",
                            "topic_id"=>"12", "id"=>"1289"} }

  subject(:homework_service) { CheckAnswerService.new(params: params, student: student) }

  context '#set_question' do
    it "sets question from params" do

    end
  end

end
