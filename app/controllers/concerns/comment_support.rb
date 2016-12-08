module CommentSupport

  def send_email(comment)
    return if comment.blank?
    if comment.has_ticket?
      ticket = comment.ticket
      SupportMailer.ticket_update(ticket.owner, ticket_url(ticket), ticket.id, comment).deliver_later
    end
  end

end
