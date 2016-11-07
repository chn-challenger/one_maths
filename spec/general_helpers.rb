def sign_in user
  visit '/'
  click_link 'Sign in'
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Log in'
end

def create_admin
  user = User.new(first_name: 'Standard', last_name: 'Admin', username: 'StandardAdmin',email: 'admin@something.com', password: '12344321',
    password_confirmation: '12344321',role:'admin')
  user.save
  user
end

def create_super_admin
  user = User.new(first_name: 'Super', last_name: 'Admin', username: 'SuperAdmin', email: 'super_admin@something.com', password: '12344321',
    password_confirmation: '12344321',role:'super_admin')
  user.save
  user
end

def create_student
  user = User.new(first_name: 'Normal', last_name: 'Student', username: 'NormalStudent', email: 'student@something.com', password: '12344321',
    password_confirmation: '12344321',role:'student')
  user.save
  user
end

def create_student_2
  user = User.new(first_name: 'Normal_2', last_name: 'Student_2', username: 'NormalStudent_2', email: 'student.2@something.com', password: '12344321',
    password_confirmation: '12344321',role:'student')
  user.save
  user
end

def create_answered_question(student, question, correctness = true, created_on = Time.now)
  ansq = AnsweredQuestion.new(user: student, question: question, correct: correctness, created_at: created_on)
  return fail 'AnsweredQuestion did not save!' unless ansq.save!
end

def create_answered_question_manager(student, question, lesson, correctness = true)
  ansq = AnsweredQuestion.new(user: student, question: question, correct: correctness, lesson_id: lesson.id)
  return fail 'AnsweredQuestion did not save!' unless ansq.save!
end

def create_course
  Course.create(name:'Science',description:'Super fun!')
end

def create_unit(course)
  course.units.create(name:'Core 1', description:'Basic maths')
end

def create_unit_2(course)
  course.units.create(name:'Core 2', description:'Core 2 maths')
end

def create_topic(unit)
  unit.topics.create(name:'Indices', description:'blank for now',level_multiplier:2)
end

def create_topic_2(unit)
  unit.topics.create(name:'Sequence', description:'description for Sequence', level_multiplier:3)
end

def create_lesson(topic)
  topic.lessons.create(name:'Test lesson', description:'Lesson desc',
    pass_experience:1000)
end

def create_lesson_2(topic)
  topic.lessons.create(name:'Test lesson 2', description:'Lessons 2 desc',
    pass_experience:1000)
end

def create_question(number)
  Question.create(question_text:"question text #{number}",
    solution:"solution #{number}", experience: 100)
end

def create_question_with_order(number,order)
  Question.create(question_text:"question text #{number}",
    solution:"solution #{number}", experience: 100, order: order)
end

def create_question_with_order_exp(number,order,exp)
  Question.create(question_text:"question text #{number}",
    solution:"solution #{number}", experience: exp, order: order)
end

def create_choice(question,number,correct)
  question.choices.create(content:"Possible solution #{number}",
    correct:correct)
end

def create_answer(question,number)
  question.answers.create(label:"x#{number}",solution:"#{number}#{number}",
    hint: "answer hint #{number}")
end

def create_answer_with_two_values(question,number,value_1,value_2)
  question.answers.create(label:"x#{number}",solution:"#{value_1},#{value_2}",
    hint: "answer hint #{number}")
end

def create_answers(question,answers)
  answers.each do |answer|
    question.answers.create(label:answer[0],solution:answer[1],hint:"")
  end
end

def create_student_lesson_exp(student,lesson,exp)
  StudentLessonExp.create(user_id:student.id, lesson_id:lesson.id, exp:exp)
end

def create_student_topic_exp(student,topic,exp)
  StudentTopicExp.create(user_id:student.id, topic_id:topic.id, exp:exp)
end

def tex_upload_file
  Rails.root + "spec/fixtures/Questions_Differentiation.tex"
end

def create_image(image_name)
  Image.create!(name: image_name)
end

def create_tag(tag_name)
  Tag.create!(name: tag_name)
end
