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

  def self.exp_and_level(user,topic)
    record = self.find_by(user,topic)
    if record.nil?
      return {current_level: 0, next_level_exp: topic.level_one_exp,
        current_level_exp: 0}
    else
      i = 0
      currt_lvl_exp = record.topic.level_one_exp
      excess_exp = record.topic_exp - currt_lvl_exp
      while 0 <= excess_exp  do
        i += 1
        currt_lvl_exp *= record.topic.level_multiplier
        excess_exp -= currt_lvl_exp
      end
      return {current_level: i, next_level_exp: currt_lvl_exp.to_i,
        current_level_exp: (excess_exp + currt_lvl_exp).to_i}
    end
  end

  def self.current_level(user,topic)
    self.exp_and_level(user,topic)[:current_level]
  end

  def self.next_level_exp(user,topic)
    self.exp_and_level(user,topic)[:next_level_exp]
  end

  def self.current_level_exp(user,topic)
    self.exp_and_level(user,topic)[:current_level_exp]
  end



  # def exp_and_level
  #   i = 0
  #   currt_lvl_exp = topic.level_one_exp
  #   excess_exp = topic_exp - currt_lvl_exp
  #   while 0 <= excess_exp  do
  #     i += 1
  #     currt_lvl_exp *= topic.level_multiplier
  #     excess_exp -= currt_lvl_exp
  #   end
  #   {current_level: i, next_level_exp: currt_lvl_exp.to_i,
  #     current_level_exp: (excess_exp + currt_lvl_exp).to_i}
  # end
  #
  # def current_level
  #   exp_and_level[:current_level]
  # end
  #
  # def next_level_exp
  #   exp_and_level[:next_level_exp]
  # end
  #
  # def current_level_exp
  #   exp_and_level[:current_level_exp]
  # end





  #
  # def self.current_level(user,topic)
  #   record = self.find_by(user,topic)
  #   if record.nil?
  #     return 0
  #   else
  #     i = 0
  #     currt_lvl_exp = record.topic.level_one_exp
  #     excess_exp = record.topic_exp - currt_lvl_exp
  #     while 0 <= excess_exp  do
  #       i += 1
  #       currt_lvl_exp *= record.topic.level_multiplier
  #       excess_exp -= currt_lvl_exp
  #     end
  #     return i
  #   end
  # end
  #
  # def self.next_level_exp(user,topic)
  #   record = self.find_by(user,topic)
  #   if record.nil?
  #     return topic.level_one_exp
  #   else
  #     i = 0
  #     currt_lvl_exp = record.topic.level_one_exp
  #     excess_exp = record.topic_exp - currt_lvl_exp
  #     while 0 <= excess_exp  do
  #       i += 1
  #       currt_lvl_exp *= record.topic.level_multiplier
  #       excess_exp -= currt_lvl_exp
  #     end
  #     return currt_lvl_exp.to_i
  #   end
  # end
  #
  # def self.current_level_exp(user,topic)
  #   record = self.find_by(user,topic)
  #   if record.nil?
  #     return 0
  #   else
  #     i = 0
  #     currt_lvl_exp = record.topic.level_one_exp
  #     excess_exp = record.topic_exp - currt_lvl_exp
  #     while 0 <= excess_exp  do
  #       i += 1
  #       currt_lvl_exp *= record.topic.level_multiplier
  #       excess_exp -= currt_lvl_exp
  #     end
  #     return (excess_exp + currt_lvl_exp).to_i
  #   end
  # end

end
