class Comment < ApplicationRecord
  belongs_to :job
  belongs_to :user
  belongs_to :ticket
end
