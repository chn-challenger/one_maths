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


# def create_question_with_answer(number)
#   Question.create(question_text:"question text #{number}",
#     solution:"solution #{number}", experience: 100,
#     answers: {"x#{number}" => ["123,456","Give whole number solutions separated by commas"]})
# end
#
# def create_question_with_two_answer(number)
#   Question.create(question_text:"question text #{number}",
#     solution:"solution #{number}", experience: 100,
#     answers: {
#       "x#{number}" => ["123,456","1 Give whole number solutions separated by commas"],
#       "y#{number}" => ["234,567","2 Give whole number solutions separated by commas"]
#     })
# end


def create_choice(question,number,correct)
  question.choices.create(content:"Possible solution #{number}",
    correct:correct)
end

def create_answer(question,number)
  question.answers.create(label:"x#{number}",solution:"#{number}#{number}",
    hint: "answer hint #{number}")
end

def create_student_lesson_exp(student,lesson,exp)
  StudentLessonExp.create(user_id:student.id, lesson_id:lesson.id, lesson_exp:exp)
end

def create_student_topic_exp(student,topic,exp)
  StudentTopicExp.create(user_id:student.id, topic_id:topic.id, topic_exp:exp)
end
