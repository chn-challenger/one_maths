class StudentTopicExp < ApplicationRecord
  belongs_to :user
  belongs_to :topic

  def self.current_exp(user,topic)
    user_id = user.is_a?(User) ? user.id : user
    topic_id = topic.is_a?(Topic) ? topic.id : topic
    record = where(user_id: user_id, topic_id: topic_id).first
    record.nil? ? 0 : record.topic_exp
  end

end
