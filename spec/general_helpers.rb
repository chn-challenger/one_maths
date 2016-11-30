def sign_in user
  visit '/'
  click_link 'Sign in'
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Log in'
end

def sign_out
  click_link 'Sign out'
end

def create_admin
  user = User.new(first_name: 'Black', last_name: 'Widow', username: 'Angel',email: 'admin@something.com', password: '12344321',
    password_confirmation: '12344321',role:'admin')
  user.save
  user
end

def create_super_admin
  user = User.new(first_name: 'Bruce', last_name: 'Wayne', username: 'Batman', email: 'super_admin@something.com', password: '12344321',
    password_confirmation: '12344321',role:'super_admin')
  user.save
  user
end

def create_student
  user = User.new(first_name: 'Roger', last_name: 'Dodger', username: 'IronMan', email: 'student@something.com', password: '12344321',
    password_confirmation: '12344321',role:'student')
  user.save
  user
end

def create_student_2
  user = User.new(first_name: 'Ray', last_name: 'Donovan', username: 'Mandarin', email: 'student.2@something.com', password: '12344321',
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

def create_question(number, lesson=nil)
  question = Question.new(question_text:"question text #{number}",
    solution:"solution #{number}", order: 1, experience: 100)
  question.save!
  unless lesson.nil?
    lesson.questions << question
  end
  question
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

def create_answer(question, number, solution=nil, type=nil)
  solution ||= [number, number]
  type ||= "normal"
  question.answers.create(label:"x#{number}",solution:"#{solution[0]}#{solution[1]}",
    hint: "answer hint #{number}", answer_type: type)
end

def create_answer_with_two_values(question,number,value_1,value_2)
  question.answers.create(label:"x#{number}",solution:"#{value_1},#{value_2}",
    hint: "answer hint #{number}")
end

def create_answers(question,answers, type='normal')
  answers.each do |answer|
    question.answers.create(label:answer[0],solution:answer[1],hint:"", answer_type: type)
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

def create_job(number,example_id)
  job = Job.create(name:"Job #{number}",description:"Job description #{number}",
                   example_id: example_id, price: number*2.5, duration: number)
  job.examples << Question.find(example_id)
  job
end

def create_job_via_post(name, description, example_id, price, duration, q_num)
  sign_in admin
  visit "/jobs"
  click_link 'Add A Job'
  fill_in "Name", with: name
  fill_in "Description", with: description
  fill_in "Example", with: example_id
  select duration.to_s, from: "Duration"
  fill_in 'Number of questions', with: q_num
  fill_in "Price", with: price.to_s
  click_button "Create Job"
  sign_out
  Job.last
end

def assign_job(job, user)
  user.assignment << job
end

def create_question_writer(num)
  User.create(email: "question_writer#{num}@something.com", password: '12344321',
    password_confirmation: '12344321',role:'question_writer')
end

def complete_job_questions(job, number)
  job.job_questions.each do |question|
    question.update(question_text:"question text #{number}",
      solution:"solution #{number}", experience: 100, order: 1, difficulty_level: 1 )
  end
end

def add_choices_answers(job)
  bool = true
  job.job_questions.each_with_index do |question, i|
    if i % 2 == 0
      create_choice(question, i+1, true)
    else
      create_answer(question, i+1)
    end
  end
end

def add_choices(job)
  job.job_questions.each_with_index do |question, i|
    create_choice(question, i+1, true)
  end
end

def last_question
  Question.last
end
