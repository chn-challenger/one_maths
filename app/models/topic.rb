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

  # def random_question(user=nil)
  #   answered_questions = []
  #   user.answered_questions.each do |a|
  #     answered_questions << Question.find(a.question_id)
  #   end
  #   (questions - answered_questions).sample
  # end

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
    topic_level = StudentTopicExp.current_level(user, self)
    question_level = sample_question_lvl(topic_level)

    question_pool = topic_questions_pool(user) + lesson_question_pool(user)
    return nil if question_pool.empty?

    extract_question(question_pool, question_level)
  end

  def extract_question(questions, level)
    questions.select { |question| question.difficulty_level == level }.sample
  end

  def sample_question_lvl(topic_level)
    case topic_level
    when 2
      [1,1,2,3].sample
    when 3
      [1,2,2,2,3].sample
    when 4
      [2,3].sample
    end
  end
end
