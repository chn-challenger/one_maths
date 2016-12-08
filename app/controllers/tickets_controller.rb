class TicketsController < ApplicationController
  include Tagable
  include TicketSupport
  before_action :authenticate_user!
  before_action :find_ticket, except: [:index, :new, :create, :archive]
  load_and_authorize_resource

  # skip_authorize_resource only: [:assign, :reset_exp, :create, :update]

  def index
    @tickets = session[:archive] ? Ticket.where(status: 'Closed') : Ticket.all
  end

  def show
    @comment = Comment.new
    @question = @ticket.questions.first
  end

  def new
    @ticket = Ticket.new
    @question = params[:question_id]
    @streak_mtp = params[:streak_mtp]
  end

  def create
    ticket = Ticket.create(ticket_params)
    tag_names = params[:tag]['Category']
    question = Question.find(params[:ticket][:question_id])
    comment = Comment.create(text: params[:description], author: current_user.email)
    if ticket.save!
      add_tags(ticket, tag_sanitizer(tag_names))
      ticket.comments << comment
      ticket.questions << question

      mail_subject = 'One Maths User Support [' + tag_names + ']'
      SupportMailer.ticket_acknowledgement(current_user, ticket_url(ticket), ticket.id, mail_subject).deliver_later

      flash[:notice] = "Successfully created a ticket ##{ticket.id}"
      redirect_to "/units/#{get_unit_id(question)}"
    else
      flash[:alert] = 'Something went wrong in the process of saving the ticket.'
      redirect_back(fallback_location: root_path)
    end
  end

  def edit

  end

  def update
    if @ticket.update(ticket_params)
      award_exp = amend_exp(@ticket) if params[:award_exp] == 'true'

      SupportMailer.ticket_resolved(@ticket.owner, ticket_url(@ticket), @ticket.id, award_exp).deliver_later

      flash[:notice] = "Successfully updated ##{@ticket.id}"
    else
      flash[:alert] = "Something went wrong in the process of updating the ticket."
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @ticket.destroy
    flash[:notice] = "Successfully deleted ticket"
    redirect_back(fallback_location: root_path)
  end

  def archive
    session[:archive] = params[:archive_view]
    redirect_back(fallback_location: tickets_path)
  end

  private

  def find_ticket
    @ticket = Ticket.find(params[:id])
  end

  def ticket_params
    params.require(:ticket).permit(:owner_id, :title, :agent_id, :status, :streak_mtp)
  end

end
