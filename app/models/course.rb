class Course < ApplicationRecord
  after_initialize :set_defaults, unless: :persisted?
  # The set_defaults will only work if the object is new

  has_many :units, dependent: :destroy
  has_and_belongs_to_many :users
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id, optional: true

  private

  def set_defaults
    self.status ||= 'private'
  end
end
