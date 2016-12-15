module TopicsHelper

  def topic_unlocked?(lessons, current_user)
    lesson_pass_exps = lessons.order(:id).pluck(:pass_experience)
    unlocked = false
    lesson_exp = nil

    lessons.order(:id).pluck(:id).each_with_index do |lesson_id, i|
      lesson_exp = StudentLessonExp.find_by(user_id: current_user.id, lesson_id: lesson_id)

      return false if lesson_exp.blank?

      return false if !(lesson_exp.exp >= lesson_pass_exps[i])

      unlocked = true
    end

    unlocked
  end
end
