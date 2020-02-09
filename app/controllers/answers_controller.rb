class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: %i[create new]
  before_action :load_answer, only: %i[destroy update choose_best]
  before_action :ensure_current_user_is_answer_author!, only: %i[update destroy]
  before_action :ensure_current_user_is_question_author!, only: %i[choose_best]

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question = @question
    @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy
  end

  def choose_best
    @current_best_answer = @answer.update_and_get_current_best!
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def ensure_current_user_is_answer_author!
    return if current_user.author_of?(@answer)

    redirect_to root_path, notice: t('.wrong_author')
  end

  def ensure_current_user_is_question_author!
    return if current_user.author_of?(@answer.question)

    redirect_to root_path, notice: t('.wrong_author')
  end
end
