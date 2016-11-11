module JobsHelper

  def id_extractor(string)
    string.split(/\s*,\s*/)
  end

  def create_job_questions(n)
    result = []
    n.times { result << Question.create!(experience: 10) }
    result
  end

  def create_job_test_env(question_ids)
    desc = 'This is a standard component generated for testing purposes.'
    unit = Unit.create!(name: 'Maths', description: desc )
    topic = Topic.create!(name: 'Calculus', description: desc,
                          level_one_exp: 1000, unit_id: unit.id
                         )
    lesson = Lesson.create!(name: 'Lesson 1', description: desc,
                            pass_experience: 500, topic_id: topic.id
                           )
    lesson.questions << Question.find(question_ids)
    lesson.save!
    unit
  end

  def get_example_question(question_id)
    job_id = Question.find(question_id).job_id
    Job.find(job_id).examples.first
  end

  def prep_new_answers(question, num)
    answers = []
    num.times { answers << question.answers.new }
    answers
  end

  def prep_new_choices(question, num)
    choices = []
    num.times { choices << question.choices.new }
    choices
  end

  def ready_to_test(questions)
    questions.each { |question| return false unless question.complete? }
  end
end
