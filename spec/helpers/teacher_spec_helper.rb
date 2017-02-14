def create_invitation(sender:, invitee:)
  Invitation.create(sender: sender, invitee: invitee)
end

def create_lesson_homework(student, lesson, exp=20)
  student.homework.create(lesson_id: lesson.id, target_exp: exp)
end

def create_topic_homework(student, topic, exp=30)
  student.homework.create(topic_id: topic.id, target_exp: exp)
end
