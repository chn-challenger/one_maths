class Job < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: :creator_id
  belongs_to :worker, class_name: "User", foreign_key: :worker_id
  has_and_belongs_to_many :examples, class_name: "Question", join_table: "jobs_questions"
  has_many :job_questions, class_name: "Question", foreign_key: :job_id, dependent: :destroy
  has_one :unit, dependent: :destroy
  has_many :images, inverse_of: :job, dependent: :destroy
  has_many :comments, class_name: 'Comment' , dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true

  def worker?
    !self.worker_id.blank?
  end

  def archived?
    self.status == 'Archived' && !self.completed_by.nil?
  end

  def due_date
    self.updated_at + self.duration.days
  end

  def has_status?
    !self.status.blank?
  end
end
