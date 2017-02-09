module TeachersHelper

  def set_as_homework?(record, user)
    record_class = record.class.to_s.downcase
    user_homeworks = user.homework.map { |homework| homework.public_send(record_class) }
    return user_homeworks.include?(record) if !block_given?
    yield(user_homeworks)
  end

  def homework_as_pass_exp?(lesson, user)
    homework = user.homework.find_by(lesson: lesson)
    return if homework.blank?
    homework.target_exp == lesson.pass_experience
  end

  def fetch_homework(record, user)
    record_class = record.class.to_s.downcase
    query_hash = {"#{record_class}": record}
    user.homework.find_by(query_hash)
  end

  def homework_indicator(record, user=current_user)
    html_id = "record-#{record.class.to_s.downcase}-#{record.id}"
    if record.is_a?(Unit) && has_homework_for?(record, user)
      css_class = homework_complete?(record, user) ? "homework-star burst-8 green-bg" : "homework-star burst-8"
      content_tag(:span, nil, class: css_class, id: html_id)
    else
      css_class = homework_complete?(record, user) ? "homework-star burst-8-topic green-bg" : "homework-star burst-8-topic"
      content_tag(:span, nil, class: css_class, id: html_id) if has_homework_for?(record, user)
    end
  end

  def homework_form(lesson:, user: current_user)
    student_lesson_exp = StudentLessonExp.find_with_user(user, lesson)
    current_user_exp = student_lesson_exp.exp unless student_lesson_exp.blank?
    homework = fetch_homework(lesson, user)
    return if current_user_exp == lesson.pass_experience && homework.blank?

    pass_exp = homework_as_pass_exp?(lesson, user)
    set_target_exp = homework.present? ? homework.target_exp : nil

    content_tag(:div, class: 'homework-checkbox') do
      form_fields = []
      form_fields << label_tag("lesson-homework-#{lesson.id}", 'Pass lesson')
      form_fields << check_box_tag('homework[lesson_ids][]', lesson.id, pass_exp,
                    id: "lesson-homework-#{lesson.id}",
                    class: 'pass-lesson-checkbox') + '</br>'.html_safe
      form_fields << number_field_tag('', set_target_exp, min: current_user_exp, max: lesson.pass_experience, step: 1, id: "target-exp-#{lesson.id}", disabled: pass_exp) + '</br>'.html_safe
      form_fields << range_field_tag("sliders", set_target_exp, min: current_user_exp, max: lesson.pass_experience, step: 1, class: 'range-slider', id: lesson.id, disabled: pass_exp)
      form_fields.join.html_safe
    end
  end

  def has_homework_for?(record, user=nil)
    user ||= current_user
    return false if current_user.blank? || user.homework.blank?

    if record.is_a?(Unit)
      return user.homework.map { |homework| homework.unit }.include?(record)
    end

    if record.is_a?(Topic)
      return user.homework.map { |homework| [homework.topic, homework.lesson_topic] }.flatten.include?(record)
    end

    if record.is_a?(Lesson)
      return set_as_homework?(record, user)
    end
  end

  def homework_complete?(record, user=nil)
    user ||= current_user
    if record.is_a?(Lesson)
      homework = user.homework.find_by(lesson: record)
      return if homework.blank?
      homework.complete?
    elsif record.is_a?(Unit)
      homeworks = user.homework.select { |homework| homework.units.include?(record) }
      return if homeworks.blank?
      homeworks.each do |homework|
        return false if !homework.complete?
      end
    elsif record.is_a?(Topic)
      homeworks = user.homework.select { |homework| homework.topics.include?(record) }
      return if homeworks.blank?
      homeworks.each do |homework|
        return false if !homework.complete?
      end
    end
  end

end
