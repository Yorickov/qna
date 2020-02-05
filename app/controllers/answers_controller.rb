class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: %i[create new]
  before_action :load_answer, only: %i[destroy update]
  before_action :ensure_current_user_is_answer_author!, only: %i[update destroy]

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
    @question = @answer.question
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
end
