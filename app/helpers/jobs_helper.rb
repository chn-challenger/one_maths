module JobsHelper

  def has_worker?(job)
    !job.worker.blank?
  end

  def print_job_date(job)
    job.due_date.strftime("Due on %m/%d/%Y at %I:%M%p")
  end

  def id_extractor(string)
    string.split(/\s*,\s*/)
  end

  def create_job_questions(n)
    result = []
    n.to_i.times { result << Question.create!(experience: 10) }
    result
  end

  def create_job_test_env(questions, job_id)
    desc = 'This is a standard component generated for testing purposes.'
    unit = Unit.create!(name: 'Maths', description: desc )
    topic = Topic.create!(name: "Test Chapter Job-#{job_id}", description: desc,
                          level_one_exp: 1000, unit_id: unit.id, level_multiplier: 1.5
                         )
    lesson = Lesson.create!(name: 'Lesson 1', description: desc,
                            pass_experience: 500, topic_id: topic.id
                           )
    lesson.questions << questions
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

  def ready_to_test?(questions)
    questions.each do |question|
      return false if !question_ready?(question)
    end
  end

  def question_ready?(question)
    return true if question.complete? && (question.choices.size >= 1 || question.answers.size >= 1)
    false
  end

 def fetch_archived_jobs
   Job.where(status: 'Archived')
 end

 def fetch_pending_jobs
   Job.where(status: 'Pending Review')
 end

 def matches_criteria?(job)
   return true unless job.worker_id.nil?
   return true if job.status == 'Archived'
   return true if job.status == 'In Progress'
 end

end
