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

  def lesson_question_pool(user)
    question_pool = []
    lessons = Lesson.where(topic: self)

    lessons.each do |lesson|
      reset_questions(lesson, user)
      question_pool += lesson.unanswered_questions(user, self)
    end
    question_pool.uniq
  end

  def topic_questions_pool(user)
    answered_q_ids = AnsweredQuestion.where(user_id: user, topic_id: self.id).pluck(:question_id)
    self.questions.where.not(id: answered_q_ids)
  end

  def random_question(user)
    topic_level = StudentTopicExp.current_level(user, self) + 1
    # p "Topic lvl: " + topic_level.to_s
    question_level = sample_question_lvl(user, topic_level)
    set_reward_mtp(user, question_level, topic_level)

    # p "Question lvl: #{question_level}"
    question_pool = topic_questions_pool(user) + lesson_question_pool(user)
    return nil if question_pool.empty?

    extract_question(question_pool, question_level)
  end

  def set_reward_mtp(user, question_level, topic_level)
    config = load_config
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
    topic_exp = StudentTopicExp.find_by(user, self)
    config = load_config
    streak_mtp = topic_exp.blank? ? 1 : topic_exp.streak_mtp

    level_one = if config['lower_level']*(1-streak_mtp) < config['lower_min']
      0
    else
      config['lower_level']*(1-streak_mtp)
    end

    level_three = if config['upper_level']*streak_mtp < config['upper_min']
      0
    else
      config['upper_level']*streak_mtp
    end

    level_two = 1 - level_one - level_three

    levels = [level_two.round.to_i, level_one.round.to_i, level_three.round.to_i]
    question_levels = [topic_level - 1, topic_level, topic_level + 1]
    p question_levels
    levels = levels.map.with_index { |level, i| validate_level_existance(user, question_levels[i]) ? level : 0 }
    p levels
    prob_array = [Array.new(levels[0], question_levels[0]),
                  Array.new(levels[1], question_levels[1]),
                  Array.new(levels[2], question_levels[2])].flatten

    prob_array.delete(5)
    p prob_array
    prob_array.sample
  end

  def validate_level_existance(user, question_level)
    question_pool = topic_questions_pool(user) + lesson_question_pool(user)
    p extract_question(question_pool, question_level)
    !extract_question(question_pool, question_level).blank?
  end

  def load_config
    YAML.load_file "#{Rails.root}/config/one_maths_config.yml"
  end
end
