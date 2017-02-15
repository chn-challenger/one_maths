class Homework < ApplicationRecord
  belongs_to :student, class_name: 'User'
  belongs_to :lesson, optional: true
  belongs_to :topic, optional: true
  # belongs_to :teacher, class_name: 'User', through: :student

  has_one :lesson_topic, class_name: 'Topic', through: :lesson, source: :topic
  has_one :topic_unit, class_name: 'Unit', through: :topic, source: :unit
  has_many :questions, through: :answered_questions

  delegate :unit, to: :lesson

  def complete?
    record = get_homework_subject
    experience_class = "Student#{record.class}Exp".constantize
    experience = experience_class.find_with_user(self.student, record)
    return false if experience.blank?
    target_exp <= experience.exp
  end

  def topics
    [self.topic, self.lesson_topic]
  end

  def lessons
    [lesson]
  end

  def units
    lesson_unit = self.unit unless lesson.blank?
    [lesson_unit, self.topic_unit]
  end

  def courses
    lesson_unit = self.unit unless lesson.blank?
    topic_unit = self.topic_unit
    units = [lesson_unit, topic_unit].compact
    return [] if units.blank?
    units.map { |unit| unit.course }
  end

  private

  def get_homework_subject
    self.lesson || self.topic
  end
end
