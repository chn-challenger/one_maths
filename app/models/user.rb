class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  has_many :courses
  has_many :units
  has_many :topics
  has_many :lessons
  has_many :questions

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
end
