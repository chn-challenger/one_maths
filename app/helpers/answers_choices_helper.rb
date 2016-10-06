module AnswersChoicesHelper
  def new
    @referer = request.referer
    @question = Question.find(params[:question_id])
    @choices = prep_new_choices(@question) if self.class == ChoicesController
    @answers = prep_new_answers(@question) if self.class == AnswersController
  end

  def prep_new_answers(question)
    answers = []
    if can? :create, Answer
      new_answers(answers,question)
    else
      new_error_handling('answer')
    end
    answers
  end

  def prep_new_choices(question)
    choices = []
    if can? :create, Choice
      new_choices(choices,question)
    else
      new_error_handling('choice')
    end
    choices
  end

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
