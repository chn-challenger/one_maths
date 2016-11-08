module JobsHelper

  def id_extractor(string)
    string.split(/\s*,\s*/)
  end

  def create_job_questions(n)
    result = []
    n.times { result << Question.create! }
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
end
