module TeachersHelper

  def set_as_homework?(lesson, user)
    user.homework.include?(lesson)
  end

  def homework_indicator(record, user=nil)
    user ||= current_user
    html_id = "record-#{record.class.to_s.downcase}-#{record.id}"
    if record.is_a?(Unit) && has_homework_for?(record, user)
      css_class = homework_complete?(record, user) ? "homework-star burst-8 green-bg" : "homework-star burst-8"
      content_tag(:span, nil, class: css_class, id: html_id)
    else
      css_class = homework_complete?(record, user) ? "homework-star burst-8-topic green-bg" : "homework-star burst-8-topic"
      content_tag(:span, nil, class: css_class, id: html_id) if has_homework_for?(record, user)
    end
  end

  def has_homework_for?(record, user=nil)
    user ||= current_user
    return false if !current_user.present? || user.homework.blank?

    if record.is_a?(Unit)
      return user.homework.map { |lesson| lesson.unit }.include?(record)
    end

    if record.is_a?(Topic)
      return user.homework.map { |lesson| lesson.topic }.include?(record)
    end

    if record.is_a?(Lesson)
      return user.homework.include?(record)
    end
  end

  def homework_complete?(record, user=nil)
    user ||= current_user
    if record.is_a?(Lesson)
      StudentLessonExp.current_exp(user, record) >= record.pass_experience
    elsif record.is_a?(Unit)
      homework = user.homework.select { |lesson| lesson.unit == record }
      homework.each do |lesson|
        return false if !homework_complete?(lesson, user)
      end

    elsif record.is_a?(Topic)
      homework = user.homework.select { |lesson| lesson.topic == record }
      homework.each do |lesson|
        return false if !homework_complete?(lesson, user)
      end
    end
  end

end
