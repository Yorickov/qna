class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!

  before_action :load_answer, only: %i[update destroy choose_best]
  before_action :load_question, only: :create

  after_action :publish_answer, only: :create

  def create
    authorize Answer

    @answer = current_user.answers.new(answer_params)
    @answer.question = @question
    @answer.save
  end

  def update
    authorize @answer

    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    authorize @answer

    @answer.destroy
  end

  def choose_best
    authorize @answer

    @answer.set_best!
    @question = @answer.question
  end

  private

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def load_question
    @question = Question.with_attached_files.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(
      :body, files: [], links_attributes: %i[id name url _destroy]
    )
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "question_#{@question.id}_answers",
      answer: @answer,
      links: @answer.links
    )
  end
end
