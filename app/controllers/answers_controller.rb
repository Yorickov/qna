class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: %i[create new]
  before_action :load_answer, only: %i[destroy]
  before_action :filter_user_by_authorship, only: %i[destroy]

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question = @question

    if @answer.save
      redirect_to @question, notice: t('.success')
    else
      render 'questions/show'
    end
  end

  def destroy
    @answer.destroy
    redirect_to @answer.question, notice: t('.success')
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

  def filter_user_by_authorship
    return if current_user.author_of?(@answer)

    redirect_to root_path, notice: t('.wrong_author')
  end
end
