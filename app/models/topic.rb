class Topic < ApplicationRecord
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
    save and return level_one_exp
  end

  def random_question(user)
    answered_questions = []
    user.answered_questions.each do |a|
      answered_questions << Question.find(a.question_id)
    end
    (questions - answered_questions).sample
  end


end
