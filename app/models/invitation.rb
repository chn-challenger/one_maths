class Invitation < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :invitee, class_name: 'User'

end
