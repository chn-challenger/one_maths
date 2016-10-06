class AnswersController < ApplicationController
  include AnswersChoicesHelper

  def edit
    @referer = request.referer
    @answer = Answer.find(params[:id])
    unless can? :edit, @answer
      flash[:notice] = 'You do not have permission to edit an answer'
      redirect_to "/"
    end
  end

  def update
    answer = Answer.find(params[:id])
    answer.update(single_answer_params)
    # redirect_to params[:answer][:redirect]
    redirect = params[:answer][:redirect] || "/questions/new"
    redirect_to redirect
  end

  def destroy
    if can? :delete, Answer
      Answer.find(params[:id]).destroy
      referer = request.referer
      redirect_to referer
    else
      flash[:notice] = 'You do not have permission to delete an answer'
      redirect_to '/'
    end

  end

  def answer_params(single_param)
    single_param.permit(:label, :solution, :hint)
  end

  def single_answer_params
    params.require(:answer).permit(:label, :solution, :hint)
  end

end
