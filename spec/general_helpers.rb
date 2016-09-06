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
  unit.topics.create(name:'Indices', description:'blank for now')
end

def create_lesson(topic)
  topic.lessons.create(name:'Test lesson', description:'Lesson desc',
    pass_experience:1000)
end

def create_question(number)
  Question.create(question_text:"question text #{number}",
    solution:"solution #{number}", experience: 100)
end

def create_choice(question,number,correct)
  question.choices.create(content:"Possible solution #{number}",
    correct:correct)
end

def create_student_lesson_exp(student,lesson,exp)
  StudentLessonExp.create(user_id:student.id, lesson_id:lesson.id, lesson_exp:exp)
end
