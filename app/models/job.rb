class Job < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: :creator_id
  belongs_to :worker, class_name: "User", foreign_key: :worker_id
  has_and_belongs_to_many :examples, class_name: "Question", join_table: "jobs_questions"
  has_many :job_questions, class_name: "Question", foreign_key: :job_id
  has_one :unit, dependent: :destroy
end
