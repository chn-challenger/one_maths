class User < ApplicationRecord
  ROLES = %i[admin super_admin student question_writer tester teacher].freeze

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  # validates :username, uniqueness: {case_sensitive: false}

  has_and_belongs_to_many :flagged_questions, class_name: 'Question', join_table: 'questions_users'

  has_many :students, class_name: 'User', foreign_key: :teacher_id
  belongs_to :teacher, class_name: 'User'
  has_one :invitation, class_name: 'Invitation', foreign_key: :invitee_id
  has_many :invites, class_name: 'Invitation', foreign_key: :sender_id
  has_many :homework, class_name: 'Homework', foreign_key: :student_id

  has_many :courses
  has_many :units
  has_many :topics
  has_many :answered_questions, dependent: :destroy
  has_many :questions, through: :answered_questions
  has_many :question_resets, dependent: :destroy

  has_many :assignment, class_name: "Job", foreign_key: :worker_id
  has_many :jobs, class_name: "Job", foreign_key: :creator_id

  has_many :tickets, class_name: "Ticket", foreign_key: :owner_id
  has_many :assigned_tickets, class_name: "Ticket", foreign_key: :agent_id

  has_many :comments, dependent: :destroy

  has_many :current_questions, dependent: :destroy

  has_many :current_topic_questions

  has_many :student_lesson_exps, dependent: :destroy
  has_many :lessons, through: :student_lesson_exps

  has_many :student_topic_exps, dependent: :destroy
  has_many :topics, through: :student_topic_exps

  def has_role?(*roles)
    user_role = role.blank? ?  nil : self.role.to_sym
    current_roles = [user_role] & ROLES
    exists = false
    roles.flatten.each do |role|
      exists = true if current_roles.include?(role.to_sym)
    end
    exists
  end

  def make_student
    self.role = :student
  end

  def homework_for_unit(unit)
    self.homework.select { |h| h.units.include?(unit) }
  end

  def has_current_question?(lesson)
    user_current_questions = self.current_questions
    user_lesson_current_question = user_current_questions.where(lesson_id: lesson.id)

    if user_lesson_current_question.count > 1
      CURRENT_QUESTION_LOGGER.debug("Current questions for user_id: #{self.id} | count: #{user_lesson_current_question.count} | lesson_id: #{lesson.id}")
    end

    if user_lesson_current_question.empty?
      false
    else
      true
    end
  end

  def fetch_current_question(lesson)
    self.current_questions.where("lesson_id=?",lesson.id).last.question
  end

  def has_current_topic_question?(topic)
    CurrentTopicQuestion.where(topic_id: topic.id,user_id: self.id).first.present?
  end

  def fetch_current_topic_question(topic)
    current_question = self.current_topic_questions.where("topic_id=?",topic.id).first
    if current_question.present?
      current_question.question
    else
      nil
    end
  end

end
