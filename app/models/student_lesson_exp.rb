class StudentLessonExp < ApplicationRecord
  belongs_to :user
  belongs_to :lesson

  def self.current_exp(user,lesson)
    if user.is_a?(User)
      user_id = user.id
    else
      user_id = user
    end
    if lesson.is_a?(Lesson)
      lesson_id = lesson.id
    else
      lesson_id = lesson
    end
    record = StudentLessonExp.where(user_id: user_id, lesson_id: lesson_id).first
    if record.nil?
      return 0
    else
      return record.lesson_exp
    end
  end


end
