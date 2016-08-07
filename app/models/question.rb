class Question < ApplicationRecord
  belongs_to :maker
  belongs_to :lesson
end
