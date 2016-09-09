class StudentLessonExp < ApplicationRecord
  belongs_to :user
  belongs_to :lesson

  def self.current_exp(user,lesson)
    user_id = user.is_a?(User) ? user.id : user
    lesson_id = lesson.is_a?(Lesson) ? lesson.id : lesson
    record = where(user_id: user_id, lesson_id: lesson_id).first
    record.nil? ? 0 : [record.lesson_exp,Lesson.find(lesson_id).pass_experience].min
  end

end
