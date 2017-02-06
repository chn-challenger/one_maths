class Topic < ApplicationRecord
  include RecycleQuestions

  belongs_to :unit
  has_many :lessons, dependent: :destroy
  has_and_belongs_to_many :questions

  has_many :current_topic_questions, dependent: :destroy

  has_many :student_topic_exps, dependent: :destroy
  has_many :users, through: :student_topic_exps

  def level_one_exp
    level_one_exp = lessons.length == 0 ? 9999 : lessons.inject(0) do |r,l|
      r + l.pass_experience
    end

    save
    return level_one_exp
  end

  def lesson_question_pool(user, reset=nil)
    question_pool = []
    lessons = Lesson.where(topic: self)

    lessons.each do |lesson|
      reset_questions(lesson, user) if reset
      question_pool += lesson.unanswered_questions(user, self)
    end
    return lesson_question_pool(user, true) if question_pool.empty? && reset != true
    question_pool.uniq
  end

  def topic_questions_pool(user, reset=nil)
    reset_topic_questions(self, user) if reset
    answered_q_ids = AnsweredQuestion.where(user_id: user, topic_id: self.id).pluck(:question_id)
    question_pool = self.questions.where.not(id: answered_q_ids)
    return topic_questions_pool(user, true) if question_pool.empty? && reset != true
    question_pool
  end

  def random_question(user)
    topic_level = StudentTopicExp.current_level(user, self) + 1

    question_pool = topic_questions_pool(user) + lesson_question_pool(user)
    return nil if question_pool.empty?
    question_level = sample_question_lvl(user, topic_level)

    set_reward_mtp(user, question_level, topic_level)
    extract_question(question_pool, question_level)
  end

  def set_reward_mtp(user, question_level, topic_level)
    config = load_config.to_h
    config.update(config) { |k,v| v.to_f }
    topic_exp = StudentTopicExp.find_by(user, self)
    return false if topic_exp.blank?
    level_diff = question_level - topic_level
    reward_mtp = level_diff == 0 ? 1 : (level_diff + config['reward_mtp']).abs

    topic_exp.update(reward_mtp: reward_mtp)
  end

  def extract_question(questions, level)
    questions.select { |question| question.difficulty_level == level }.sample
  end

  def sample_question_lvl(user, topic_level)
    prob_array = construct_level_array(user, topic_level)
    prob_array.delete(5)

    question_pool = topic_questions_pool(user) + lesson_question_pool(user)
    confirm_level(prob_array.sample, question_pool)
  end

  def confirm_level(question_level, questions, reset_count=nil)
    if extract_question(questions, question_level).blank?
      question_level -= 1
      return confirm_level(2, questions, 1) if question_level == 0 && reset_count == nil
      return confirm_level(3, questions, reset_count) if question_level == 0 && reset_count == 1
      return confirm_level(question_level, questions, reset_count)
    else
      question_level
    end
  end

  def construct_level_array(user, topic_level)
    topic_exp = StudentTopicExp.find_by(user, self)
    config = load_config.to_h
    config.update(config) { |k,v| v.to_f }
    streak_mtp = (topic_exp.blank? ? 1 : topic_exp.streak_mtp) - 1

    level_one = if (config['lower_level']*(1 - streak_mtp)) < config['lower_min']
      0
    else
      config['lower_level']*(1 - streak_mtp)
    end

    level_three = if (config['upper_level']*streak_mtp) < config['upper_min']
      0
    else
      config['upper_level']*streak_mtp
    end

    level_two = 1 - level_one.to_f - level_three.to_f

    levels = [(level_two*10).round.to_i, (level_one*10).round.to_i, (level_three*10).round.to_i]
    question_levels = [topic_level, topic_level - 1, topic_level + 1]
    # levels = levels.map.with_index { |level, i| validate_level_existance(user, question_levels[i]) ? level : 0 }
    #
    # question_pool = topic_questions_pool(user) + lesson_question_pool(user)
    #
    # if levels == [0,0,0] && !question_pool.empty?
    #   return question_levels.each do |level|
    #            return [level] if validate_level_existance(user, question_levels[i])
    #          end
    # end

    [Array.new(levels[1], question_levels[1]),
     Array.new(levels[0], question_levels[0]),
     Array.new(levels[2], question_levels[2])].flatten
  end

  def validate_level_existance(user, question_level)
    question_pool = topic_questions_pool(user) + lesson_question_pool(user)
    !extract_question(question_pool, question_level).blank?
  end

  def load_config
    YAML.load_file "#{Rails.root}/config/one_maths_config.yml"
  end
end
