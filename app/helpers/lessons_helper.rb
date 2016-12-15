module LessonsHelper


  def visible?(lesson)
    lesson.status != 'Test'
  end

  def lesson_button(lesson)
    button = nil
    status = nil

    case lesson.status
    when "Published"
      button = 'Test'
      status = 'Test'
    when 'Test'
      button = 'Publish'
      status = 'Published'
    end

    return link_to button, lesson_path(lesson, lesson: { status: status }), id: "lesson-status-#{lesson.id}", method: :put
  end

  def lesson_bar_exp(lesson)
    lesson_exp = StudentLessonExp.current_exp(current_user,lesson)
    lesson_pass_exp = lesson.pass_experience
    ((lesson_exp / lesson_pass_exp.to_f) * 100).round(2)
  end

end
