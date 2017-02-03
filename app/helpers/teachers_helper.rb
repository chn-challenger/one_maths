module TeachersHelper

  def set_as_homework?(lesson, user)
    user.homework.include?(lesson)
  end

  def has_homework_for?(record)
    return false if !current_user.present? || current_user.homework.blank?

    if record.is_a?(Unit)
      return current_user.homework.map { |lesson| lesson.unit }.include?(record)
    end

    if record.is_a?(Topic)
      return current_user.homework.map { |lesson| lesson.topic }.include?(record)
    end

    if record.is_a?(Lesson)
      return current_user.homework.include?(record)
    end
  end

end
