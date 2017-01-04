def create_question_reset(lesson: l, question: q, user: u)
  QuestionReset.create(user: u, lesson_id: l.id, question_id: q.id)
end
