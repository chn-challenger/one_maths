def create_question_reset(lesson: l, question: q, user: u)
  QuestionReset.create(user: u, lesson_id: l.id, question_id: q.id)
end

def topic_exp_bar(user, topic, exp=nil)
  exp ||= StudentTopicExp.current_level_exp(user,topic)
  "#{exp} / #{StudentTopicExp.next_level_exp(user,topic)} \
  Lvl #{StudentTopicExp.current_level(user,topic) + 1}"
end
