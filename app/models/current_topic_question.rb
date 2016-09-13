class CurrentTopicQuestion < ApplicationRecord
  belongs_to :topic
  belongs_to :user
  belongs_to :question
end
