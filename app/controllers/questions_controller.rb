class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end

  def new
    unless can? :create, Question
      flash[:notice] = 'You do not have permission to create a question'
      redirect_to "/"
    else
      @referer = request.referer
      if URI(@referer).path == "/" || URI(@referer).path == "/questions" || @referer.split("").last(11).join == "choices/new"
        @referer = "/questions/new"
      end
      @questions = Question.all.order('created_at').last(2).reverse
      @question = Question.new
    end
  end

  def create
    redirect = params[:question][:redirect] || "/questions/new"
    q = Question.create(question_params)
    if params[:question][:lesson_id]
      l = Lesson.find(params[:question][:lesson_id])
      l.questions << q
      l.save
    end
    redirect_to redirect
  end

  def show
  end

  def check_answer
    if current_user and current_user.student?
      AnsweredQuestion.create(user_id: current_user.id, question_id:
        params[:question_id], correct: params[:choice])

      current_user.current_questions.where(question_id: params[:question_id])
        .last.destroy

      question = Question.find(params[:question_id])

      student_lesson_exp = StudentLessonExp.where(user_id: current_user.id, lesson_id: params[:lesson_id]).first ||
        StudentLessonExp.create(user_id: current_user.id, lesson_id: params[:lesson_id], lesson_exp: 0, streak_mtp: 1)

      topic = Lesson.find(params[:lesson_id]).topic
      student_topic_exp = StudentTopicExp.where(user_id: current_user.id, topic_id: topic.id ).first ||
        StudentTopicExp.create(user_id: current_user.id, topic_id: topic.id, topic_exp: 0, streak_mtp: 1)
    end
    if params[:choice] == 'true'
      result = "Correct answer! Well done!"
      student_lesson_exp.lesson_exp += (question.experience * student_lesson_exp.streak_mtp)
      student_topic_exp.topic_exp += (question.experience * student_lesson_exp.streak_mtp)
      student_lesson_exp.streak_mtp *= 1.2
      if student_lesson_exp.streak_mtp > 2
        student_lesson_exp.streak_mtp = 2
      end
      student_lesson_exp.save
      student_topic_exp.save
    else
      result = "Incorrect, have a look at the solution and try another question!"
      student_lesson_exp.streak_mtp = 1
      student_lesson_exp.save
    end
    render json: {
      message: result,
      question_solution: question.solution,
      choice: params[:choice],
      lesson_exp: StudentLessonExp.current_exp(current_user,params[:lesson_id]),
      topic_exp: StudentTopicExp.current_level_exp(current_user,topic),
      topic_next_level_exp: StudentTopicExp.next_level_exp(current_user,topic),
      topic_next_level: StudentTopicExp.current_level(current_user,topic) + 1
    }
  end

  def check_topic_answer
    if current_user and current_user.student?
      AnsweredQuestion.create(user_id: current_user.id, question_id:
        params[:question_id], correct: params[:choice])

      current_user.current_topic_questions.where(question_id: params[:question_id])
        .last.destroy

      question = Question.find(params[:question_id])

      topic = Topic.find(params[:topic_id])
      student_topic_exp = StudentTopicExp.where(user_id: current_user.id, topic_id: topic.id ).first ||
        StudentTopicExp.create(user_id: current_user.id, topic_id: topic.id, topic_exp: 0, streak_mtp: 1)
    end

    if params[:choice] == 'true'
      result = "Correct answer! Well done!"
      student_topic_exp.topic_exp += (question.experience * student_topic_exp.streak_mtp)
      student_topic_exp.streak_mtp *= 1.2
      if student_topic_exp.streak_mtp > 2
        student_topic_exp.streak_mtp = 2
      end
      student_topic_exp.save
    else
      result = "Incorrect, have a look at the solution and try another question!"
      student_topic_exp.streak_mtp = 1
      student_topic_exp.save
    end

    render json: {
      message: result,
      question_solution: question.solution,
      choice: params[:choice],
      topic_exp: StudentTopicExp.current_level_exp(current_user,topic),
      topic_next_level_exp: StudentTopicExp.next_level_exp(current_user,topic),
      topic_next_level: StudentTopicExp.current_level(current_user,topic) + 1
    }
  end

  def edit
    @redirect = request.referer
    @question = Question.find(params[:id])
    unless can? :edit, @question
      flash[:notice] = 'You do not have permission to edit a question'
      redirect_to "/questions"
    end
  end

  def update
    @question = Question.find(params[:id])
    if can? :edit, @question
      @question.update(question_params)
    else
      flash[:notice] = 'You do not have permission to edit a question'
    end
    redirect_to params[:question][:redirect]
  end

  def destroy
    referer = request.referer || "/questions/new"
    @question = Question.find(params[:id])
    if can? :delete, @question
      @question.destroy
    else
      flash[:notice] = 'You do not have permission to delete a question'
    end
    redirect_to referer
  end

  def question_params
    params.require(:question).permit(:question_text, :solution, :difficulty_level, :experience)
  end
end
