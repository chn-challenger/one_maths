class Course < ApplicationRecord
  has_many :units, dependent: :destroy
end
