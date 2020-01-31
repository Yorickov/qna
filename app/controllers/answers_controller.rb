class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: %i[create new]
  before_action :load_answer, only: %i[destroy]

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question_id = params[:question_id]

    if @answer.save
      redirect_to @question, notice: t('.success')
    else
      @question.answers.reload
      render 'questions/show'
    end
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
end
