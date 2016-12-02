module LessonsHelper

  def lesson_button(lesson)
    case lesson.status
    when "Published"
      'Draft'
    when 'Draft'
      'Publish'
    when 'Test'
      'Publish'
    end
  end

end
