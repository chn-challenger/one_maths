class Choice < ApplicationRecord

  belongs_to :question
  has_and_belongs_to_many :images

end
