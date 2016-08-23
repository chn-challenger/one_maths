class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  has_many :courses
  has_many :units
  has_many :topics
  has_many :lessons
  has_many :answered_questions
  has_many :questions, through: :answered_questions
  has_many :current_questions

  ROLES = %w[admin super_admin student parent].freeze

  def super_admin?
    role == 'super_admin'
  end

  def admin?
    role == 'admin'
  end

  def student?
    role == "student"
  end

  def make_student
    self.role = 'student'
  end

  def has_current_question?(lesson)
    user_current_questions = self.current_questions
    user_lesson_current_question = user_current_questions.where("lesson_id=?",lesson.id)
    if user_lesson_current_question.empty?
      false
    elsif user_lesson_current_question.length == 1
      user_lesson_current_question.first.question
    else
      raise 'has more than 1 current question'
    end
  end


end
