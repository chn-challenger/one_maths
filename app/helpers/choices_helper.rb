module ChoicesHelper
  # def new
  #   @referer = request.referer
  #   @question = Question.find(params[:question_id])
  #   @choices = []
  #   if can? :create, Choice
  #     new_answers(@choices,@question)
  #   else
  #     new_error_handling('choice')
  #   end
  # end

  # def new
  #   @referer = request.referer
  #   @question = Question.find(params[:question_id])
  #   @answers = []
  #   if can? :create, Answer
  #     new_answers(@answers,@question)
  #   else
  #     new_error_handling('answer')
  #   end
  # end

  def new_answers(answers,question)
    5.times{answers << question.answers.new}
  end

  def new_choices(choices,question)
    5.times{choices << question.choices.new}
  end

  def new_error_handling(name)
    flash[:notice] = "You do not have permission to create a #{name}"
    redirect_to "/questions"
  end

end
