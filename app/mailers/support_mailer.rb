class SupportMailer < ApplicationMailer
  default from: 'support@onemaths.com'

  def ticket_acknowledgement(user, url, ticket_id, subject)
    @user = user
    @url  = url
    @ticket_id = ticket_id
    mail(to: @user.email, subject: subject)
  end

  def ticket_update(user, url, ticket_id, comment)
    @user = user
    @url  = url
    @ticket_id = ticket_id
    @comment = comment
    mail(to: @user.email, subject: "One Maths User Support Ticket Update [##{ticket_id}]")
  end

  def ticket_resolved(user, url, ticket_id, award_exp)
    @user = user
    @url = url
    @ticket_id = ticket_id
    @award_exp = award_exp ||= nil
    mail(to: @user.email, subject: "One Maths User Support Ticket Update [##{ticket_id}]")
  end

end
