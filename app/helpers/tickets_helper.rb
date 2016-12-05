module TicketsHelper

  def closed?(ticket)
    ticket.status == 'Closed'
  end

  def description(ticket)
    ticket.comments.first.text[0..70] << '...'
  end

end
