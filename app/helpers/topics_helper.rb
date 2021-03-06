module TopicsHelper

  def bar_exp(topic, user=nil)
    user ||= current_user
    current_exp = StudentTopicExp.current_level_exp(user, topic)
    next_exp = StudentTopicExp.next_level_exp(user, topic)
    ((current_exp / next_exp.to_f) * 100).round(2)
  end

  def topic_unlocked?(lessons, current_user)
    lesson_pass_exps = lessons.order(:id).pluck(:pass_experience)
    unlocked = false
    lesson_exp = nil

    lessons.order(:id).each_with_index do |lesson, i|
      next if lesson.status == 'Test'

      lesson_exp = StudentLessonExp.find_by(user_id: current_user.id, lesson_id: lesson.id)

      break if lesson_exp.blank?

      break if lesson.pass_experience == 0

      break if !(lesson_exp.exp >= lesson_pass_exps[i])

      unlocked = true
    end

    unlocked
  end

  def topic_has_questions?(topic)
    topic.questions.any? || topic.lesson_question_pool(current_user).any?
  end

end
