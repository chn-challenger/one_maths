class Answer < ApplicationRecord
  after_save :set_default_order
  after_create :set_default_order

  belongs_to :question

  private

  def set_default_order
    self.order ||= self.id
  end
end
