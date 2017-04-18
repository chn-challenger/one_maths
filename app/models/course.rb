class Course < ApplicationRecord
  after_initialize :set_defaults, unless: :persisted?
  # The set_defaults will only work if the object is new

  has_many :units, dependent: :destroy
  has_and_belongs_to_many :users
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id, optional: true

  def self.status(type, **options)
    params = options.merge(status: type)
    if type == :private || type == :public
      where(params)
    else
      raise TypeError, 'unrecognised type for course status (only :private & :public)'
    end
  end

  private

  def set_defaults
    self.status ||= 'private'
  end
end
