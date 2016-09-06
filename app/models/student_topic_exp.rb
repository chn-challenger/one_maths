class StudentTopicExp < ApplicationRecord
  belongs_to :user
  belongs_to :topic

  def self.current_exp(user,topic)
    record = self.find_by(user,topic)
    record.nil? ? 0 : record.topic_exp
  end

  def self.find_by(user,topic)
    user_id = user.is_a?(User) ? user.id : user
    topic_id = topic.is_a?(Topic) ? topic.id : topic
    where(user_id: user_id, topic_id: topic_id).first
  end

  def current_level
    topic_exp
  end

end
