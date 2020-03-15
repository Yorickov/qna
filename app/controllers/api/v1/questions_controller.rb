class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: %i[show update destroy]

  def index
    @questions = Question.with_attached_files.all

    render json: @questions
  end

  def show
    render json: @question
  end

  def create
    authorize Question

    @question = current_resource_owner.questions.new(question_params)

    if @question.save
      render json: @question, status: :created
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @question

    if @question.update(question_params)
      render json: @question, status: :ok
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @question

    @question.destroy
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
