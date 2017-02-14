class BaseHomeworkService
  def calculate_target_exp(topic, user=nil, opts={})
    topic_exp_opts = fetch_topic_exp(user, topic)
    current_exp = topic_exp_opts.exp
    level_one_exp = topic.level_one_exp
    lvl_multiplier = topic.level_multiplier
    selected_lvl = opts[:level].to_i - 1

    total_exp = (0...selected_lvl).to_a.reduce(0) do |r, level|
                  r += level_one_exp * lvl_multiplier**level
                end
    ((total_exp - current_exp) + opts[:target_exp].to_i) + current_exp
  end

  private

  def fetch_topic_exp(user, topic)
    id = topic.id
    user.student_topic_exps.where(topic_id: id).first_or_create(topic_id: id, exp: 0, streak_mtp: 1)
  end
end
