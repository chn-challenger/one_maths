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

  def create
    create_answers_or_choices(:answers,:label) if self.class == AnswersController
    create_answers_or_choices(:choices,:content) if self.class == ChoicesController
  end

  def create_answers_or_choices(name,label)
    question = Question.find(params[:question_id])

    params[name].each do |name_param|
      unless name_param[label] == ""
        if AnswersHelper::ANSWER_HINTS.include?(name_param[:hint])
          name_param[:hint] = AnswersHelper::ANSWER_HINTS.index(name_param[:hint])
        end

        redirect = name_param[:redirect]
        create_answers(question,name_param) if self.class == AnswersController
        create_choices(question,name_param) if self.class == ChoicesController
      end
    end
    
    if params[name][0] == nil
      redirect = "/questions/new"
    else
      redirect = params[name][0][:redirect] || "/questions/new"
    end
    redirect_to redirect
  end

  def create_answers(question,answer_param)
    question.answers.create(answer_params(answer_param))
  end

  def create_choices(question,choice_param)
    question.choices.create(choice_params(choice_param))
  end
end
