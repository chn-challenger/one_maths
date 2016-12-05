class TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_ticket, except: [:index, :new, :create]


  def index
    @tickets = Ticket.all
  end

  def show

  end

  def new
    @ticket = Ticket.build
  end

  def create
    ticket = Ticket.create(ticket_params)
    if ticket.save!
      flash[:notice] = "Successfully created a ticket ##{ticket.id}"
    else
      flash[:alert] = 'Something went wrong in the process of saving the ticket.'
    end
    redirect_back(fallback_location: root_path)
  end

  def edit

  end

  def update
    if @ticket.update(ticket_params)
      flash[:notice] = "Successfully updated ##{@ticket.id}"
    else
      flash[:alert] = "Something went wrong in the process of updating the ticket."
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @ticket.destroy
  end

  private

  def find_ticket
    @ticket = Ticket.find(params[:id])
  end

  def ticket_params

  end

end
