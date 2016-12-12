module TicketSupport

  def get_unit_id(question)
    question.lessons.first.topic.unit.id
  end

end
