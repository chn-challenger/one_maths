module TeachersHelper

  def set_as_homework?(record, user=current_user, topic_qs: false)
    record_class = record.class.to_s.downcase
    record_class = record_class + 's' unless topic_qs
    user_homeworks = user.homework.map { |homework| homework.public_send(record_class) }.flatten
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
    unless record_class == 'unit' || record_class == 'course'
      query_hash = {"#{record_class}": record}
      user.homework.find_by(query_hash)
    else
      user.public_send("homework_for_#{record_class}", record)
    end
  end

  def homework_complete?(record, user)
    homework = fetch_homework(record, user)
    return false if homework.blank?
    if homework.is_a?(Array)
      homework.each { |h| return false unless h.complete? }
    else
      homework.complete?
    end
  end

  def homework_indicator(record, user=current_user, topic_qs: false)
    html_id = "record-#{record.class.to_s.downcase}-#{record.id}"
    if record.is_a?(Unit) && set_as_homework?(record, user, topic_qs: topic_qs)
      css_class = homework_complete?(record, user) ? "homework-star burst-8 green-bg" : "homework-star burst-8"
      content_tag(:span, nil, class: css_class, id: html_id)
    else
      css_class = homework_complete?(record, user) ? "homework-star burst-8-topic green-bg" : "homework-star burst-8-topic"
      content_tag(:span, nil, class: css_class, id: html_id) if set_as_homework?(record, user, topic_qs: topic_qs)
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
      form_fields << check_box_tag('', lesson.id, pass_exp,
                    id: "lesson-homework-#{lesson.id}",
                    class: 'pass-lesson-checkbox') + '</br>'.html_safe
      form_fields << hidden_field_tag('', set_target_exp, id: "target-exp-#{lesson.id}")
      form_fields << 'Exp: '.html_safe + content_tag(:output, set_target_exp, for: "lesson-#{lesson.id}", id: "lesson-slider-output-#{lesson.id}") + '</br>'.html_safe
      form_fields << range_field_tag("sliders", set_target_exp, min: current_user_exp, max: lesson.pass_experience, step: 1, class: 'range-slider', id: lesson.id, disabled: pass_exp)
      form_fields.join.html_safe
    end
  end

  def topic_homework_form(topic:, user:)
    homework = fetch_homework(topic, user)
    stats = topic_options(topic, user)
    set_target_exp = homework.present? ? homework.target_exp : stats[:min]

    topic_level_selection = (stats[:current_level]..Topic::MAX_LVL).to_a

    content_tag(:div, class: 'form-group topic-homework') do
      form_fields = []
      form_fields << label_tag("topic-homework-#{topic.id}", 'Select Level')
      form_fields << select_tag('', options_for_select(topic_level_selection), { id: "topic-level-#{topic.id}", class: 'level-select',
                                                                                data: { level_mtp: stats[:level_mtp],
                                                                                  level_one: stats[:lvl_one],
                                                                                  current_lvl: stats[:current_level],
                                                                                  min: stats[:min]
                                                                                }
                                                                               })
      form_fields << hidden_field_tag('', set_target_exp, id: "target-exp-topic-#{topic.id}")
      form_fields << 'Exp: '.html_safe + content_tag(:output, set_target_exp, for: "topic-#{topic.id}", id: "topic-slider-output-#{topic.id}") + '</br>'.html_safe
      form_fields << range_field_tag("sliders", set_target_exp, min: stats[:min], max: stats[:max], step: 1, class: 'range-slider', id: "topic-#{topic.id}")
      form_fields.join.html_safe
    end
  end

  def topic_options(topic, user)
    student_topic_exp = StudentTopicExp.find_with_user(user, topic)
    current_user_exp = student_topic_exp.present? ? student_topic_exp.exp : 0

    topic_level_options = StudentTopicExp.exp_and_level(user, topic)
    current_level = topic_level_options[:current_level]
    level_mtp = topic.level_multiplier
    level_one_exp = topic.level_one_exp
    min = topic_level_options[:current_level_exp]
    max = (level_mtp**(current_level)) * level_one_exp

    { min: min.to_i, max: max.to_i, current_level: current_level + 1,
      level_mtp: level_mtp, lvl_one: level_one_exp }
  end

  def required_exp(lvl_mtp, current_lvl, lvl_one_exp)
    (0...current_lvl).to_a.reduce(0) do |r, level|
      r += lvl_one_exp * lvl_mtp**level
    end
  end

end
