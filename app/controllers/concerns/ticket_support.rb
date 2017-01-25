module TicketSupport
  extend ActiveSupport::Concern

  def get_unit_id(question)
    question.lessons.first.topic.unit.id
  end

  def fetch_tickets
    return Ticket.where(status: 'Closed').order(updated_at: :desc) if session[:archive]
    return Ticket.all.order(created_at: :desc) if current_user.admin? || current_user.super_admin?
    Ticket.where(owner: current_user).order(status: :desc)
  end

end
