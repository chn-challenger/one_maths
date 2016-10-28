module ManagementHelper
  def get_topic_exp(topic_id, student_id)
    StudentTopicExp.where(topic_id: topic_id, user_id: student_id).first.exp
  end

  def get_lesson_exp(lesson_id, student_id)
    if !!lesson_id && !!student_id
      StudentLessonExp.where(lesson_id: lesson_id, user_id: student_id).first.exp
    else
      return 0
    end
  end
end
