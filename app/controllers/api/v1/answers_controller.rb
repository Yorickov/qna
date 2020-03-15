class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question, only: %i[index create]
  before_action :load_answer, only: %i[show update destroy]

  def index
    render json: @question.answers.with_attached_files
  end

  def show
    render json: @answer
  end

  def create
    authorize Answer

    @answer = current_resource_owner.answers.new(
      answer_params.merge(question: @question)
    )

    if @answer.save
      render json: @answer, status: :created
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @answer

    if @answer.update(answer_params)
      render json: @answer, status: :ok
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @answer

    @answer.destroy
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
