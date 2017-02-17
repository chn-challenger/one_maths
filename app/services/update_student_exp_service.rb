class UpdateStudentExpService

  def initialize(topic_exp:, lesson_exp:, correctness:, question:, topic_question:)
    @lesson_exp = lesson_exp
    @topic_exp = topic_exp
    @correctness = correctness
    @question = question
    @topic_question = topic_question
  end

  def update_user_experience
    return unless correct?
    calculated_exp = topic_question? ? calculate_topic_exp : calculate_lesson_exp

    update_lesson_exp(update_exp: calculated_exp)
    update_topic_exp(update_exp: calculated_exp)
  end

  def update_lesson_exp(update_exp: nil)
    return if topic_question? || !correct?

    lesson_exp.exp += update_exp
    lesson_exp.save
  end

  def update_topic_exp(update_exp: nil)
    return unless correct?

    topic_exp.exp += update_exp
    topic_exp.save
  end

  def calculate_lesson_exp
    return 0 unless correct?
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

  private

  attr_accessor :correctness, :question, :lesson_exp, :topic_exp

  def topic_question?
    @topic_question
  end

  def correct?
    correctness > 0 && correctness != 0
  end
end
