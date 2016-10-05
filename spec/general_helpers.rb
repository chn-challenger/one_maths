def sign_in user
  visit '/'
  click_link 'Sign in'
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Log in'
end

def create_admin
  user = User.new(email: 'admin@something.com', password: '12344321',
    password_confirmation: '12344321',role:'admin')
  user.save
  user
end

def create_student
  user = User.new(email: 'student@something.com', password: '12344321',
    password_confirmation: '12344321',role:'student')
  user.save
  user
end

def create_course
  Course.create(name:'Science',description:'Super fun!')
end

def create_unit(course)
  course.units.create(name:'Core 1', description:'Basic maths')
end

def create_topic(unit)
  unit.topics.create(name:'Indices', description:'blank for now',level_multiplier:2)
end

def create_lesson(topic)
  topic.lessons.create(name:'Test lesson', description:'Lesson desc',
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
