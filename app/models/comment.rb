class Comment < ApplicationRecord
  belongs_to :job
  belongs_to :user
  belongs_to :ticket

  def has_ticket?
    !self.ticket.blank?
  end

end
