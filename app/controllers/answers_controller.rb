class AnswersController < ApplicationController

  def new
    @referer = request.referer
    @question = Question.find(params[:question_id])
    if can? :create, Answer
      @answers = []
      5.times{@answers << @question.answers.new}
    else
      flash[:notice] = 'You do not have permission to create a answer'
      redirect_to "/questions"
    end
  end

  def create
    referer = "/questions/new"
    question = Question.find(params[:question_id])
    params[:answers].each do |answer_param|
      unless answer_param[:label] == ""
        referer = answer_param[:redirect]
        question.answers.create(answer_params(answer_param))
      end
    end
    redirect_to referer
  end

  # def edit
  #   @referer = request.referer
  #   @choice = Choice.find(params[:id])
  #   unless can? :edit, @choice
  #     flash[:notice] = 'You do not have permission to edit a choice'
  #     redirect_to "/questions"
  #   end
  # end
  #
  # def update
  #   choice = Choice.find(params[:id])
  #   choice.update(single_choice_params)
  #   redirect_to params[:choice][:redirect]
  # end
  #
  # def destroy
  #   referer = request.referer
  #   @choice = Choice.find(params[:id])
  #   if can? :delete, @choice
  #     @choice.destroy
  #   else
  #     flash[:notice] = 'You do not have permission to delete a choice'
  #   end
  #   redirect_to referer
  # end

  def answer_params(single_param)
    single_param.permit(:label, :solution, :hint)
  end

  def single_answer_params
    params.require(:answer).permit(:label, :solution, :hint)
  end

end
