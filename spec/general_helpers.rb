def sign_up_tester
  visit('/')
  click_link('Sign up')
  fill_in('Email', with: 'tester@example.com')
  fill_in('Password', with: 'testtest')
  fill_in('Password confirmation', with: 'testtest')
  click_button('Sign up')
  visit "/courses"
end

def sign_in_maker
  visit '/'
  click_link 'Sign in'
  fill_in 'Email', with: 'maker@maker.com'
  fill_in 'Password', with: '12344321'
  click_button 'Log in'
  visit '/'
end

def create_maker
  maker = Maker.create(email: 'maker@maker.com', password: '12344321',
    password_confirmation: '12344321')
end

def create_course(maker)
  maker.courses.create(name:'Science',description:'Super fun!')
end

def create_unit(course,maker)
  course.units.create_with_maker({name:'Core 1', description:'Basic maths'},maker)
end

def create_topic(unit,maker)
  unit.topics.create_with_maker({name:'Indices', description:'blank for now'},maker)
end

def create_lesson(topic,maker)
  topic.lessons.create_with_maker({name:'Index multiplication',
    description:'times divide power again of indices',video:"0QjF6A3Zwkk"},
    maker)
end

def create_question(lesson,maker)
  lesson.questions.create_with_maker({question_text:'Solve $2+x=5$',
    solution:'$x = 3$'},maker)
end
