class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: %i[show]

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: @question
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end
end
