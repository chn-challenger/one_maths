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

def create_topic(unit,maker)
  unit.topics.create_with_maker({name:'Indices', description:'blank for now'},maker)
end

def create_lesson(topic,maker)
  topic.lessons.create_with_maker({name:'Index multiplication',
    description:'times divide power again of indices',video:"0QjF6A3Zwkk"},
    maker)
end

def create_question(maker,number)
  params = {question_text:"question text #{number}",
    solution:"solution #{number}"}
  maker.questions.create(params)
end

def create_choice(question,maker,number)
  question.choices.create_with_maker({content:"Possible solution #{number}",
    correct:false},maker)
end
