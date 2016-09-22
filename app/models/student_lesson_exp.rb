class StudentLessonExp < ApplicationRecord
  belongs_to :user
  belongs_to :lesson

  def self.current_exp(user,lesson)
    record = self.find_with_user(user,lesson)
    lesson_id = lesson.is_a?(Lesson) ? lesson.id : lesson
    record.nil? ? 0 : [record.exp,Lesson.find(lesson_id).pass_experience].min
  end

  def self.find_with_user(user, lesson)
    user_id = user.is_a?(User) ? user.id : user
    lesson_id = lesson.is_a?(Lesson) ? lesson.id : lesson
    where(user_id: user_id, lesson_id: lesson_id).first
  end

  def self.get_streak_bonus(user, lesson)
    record = self.find_with_user(user, lesson)
    if record.nil?
      0
    else
      (record.streak_mtp - 1)
    end
  end
end
