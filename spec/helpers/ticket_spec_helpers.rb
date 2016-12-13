def archive_ticket(ticket)
  ticket.update_attributes(status: 'Closed')
end
