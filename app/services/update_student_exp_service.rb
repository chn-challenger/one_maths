class UpdateStudentExpService

  def initialize(topic_exp:, lesson_exp:, correctness:, question:, topic_question:)
    @lesson_exp = lesson_exp
    @topic_exp = topic_exp
    @correctness = correctness
    @question = question
    @topic_question = topic_question
  end

  def update_user_experience
    return if correctness < 1


  end

  def update_lesson_exp(correct, lesson_exp, question)
    return unless correct
    calculated_exp = calculate_exp(lesson_exp, question)

    lesson_exp.exp += calculated_exp
    lesson_exp.save
  end

  def update_topic_exp(correct, lesson_exp, topic_exp, question, topic_question=false)
    return unless correct
    calculated_exp = if topic_question
        calculate_topic_exp(topic_exp, question)
      else
        calculate_exp(lesson_exp, question, 1)
      end

    topic_exp.exp += calculated_exp
    topic_exp.save
  end

  def update_partial_lesson_exp(partial:, lesson_exp:, question:)
    return unless partial > 0 && partial < 0.99
    calculated_exp = calculate_exp(lesson_exp, question, partial)

    lesson_exp.exp += calculated_exp
    lesson_exp.save
  end

  def update_partial_topic_exp(partial:, lesson_exp:, topic_exp:, question:, topic_question: false)
    return unless partial > 0 && partial < 0.99
    calculated_exp = if topic_question
        calculate_topic_exp(topic_exp, question, partial)
      else
        calculate_exp(lesson_exp, question, partial)
      end

    topic_exp.exp += calculated_exp
    topic_exp.save
  end

  def calculate_lesson_exp
    streak_mtp = lesson_exp.streak_mtp
    calculated_exp = (question.experience * correctness * streak_mtp).to_i
    lesson_pass_exp = lesson_exp.lesson.pass_experience
    total_exp = calculated_exp + lesson_exp.exp

    if lesson_exp.exp >= lesson_pass_exp
      calculated_exp = 0
    elsif lesson_pass_exp < total_exp
      difference = total_exp - lesson_pass_exp
      calculated_exp = calculated_exp - difference
    end

    calculated_exp
  end

  def calculate_topic_exp
    reward_mtp = topic_exp.reward_mtp
    streak_mtp = topic_exp.streak_mtp
    (question.experience * correctness * streak_mtp * reward_mtp).to_i
  end

  def lesson_max_exp?(lesson_exp, topic_exp)
    lesson_exp.exp >= lesson_exp.lesson.pass_experience && (topic_exp.exp != 0)
  end

  private

  attr_accessor :correctness, :question, :lesson_exp, :topic_exp

  def topic_question?
    @topic_question
  end
end
