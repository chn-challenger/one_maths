module TopicsHelper

  def bar_exp(topic)
    current_exp = StudentTopicExp.current_level_exp(current_user, topic)
    next_exp = StudentTopicExp.next_level_exp(current_user, topic)
    ((current_exp / next_exp.to_f) * 100).round(2)
  end

end
