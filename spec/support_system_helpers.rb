def create_support_ticket(question, usr, comment=nil, status='Open')
  ticket = Ticket.create(owner_id: usr.id, status: status)
  ticket.tags << Tag.where(name: 'Question Error').first_or_create(name: 'Question Error')
  ticket.questions << question
  ticket.comments << Comment.create(author: usr.email, text: comment)
  ticket
end
