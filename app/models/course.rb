class Course < ApplicationRecord
  belongs_to :maker
  has_many :units
end
