class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_current_user_is_answer_author!, only: %i[update destroy]
  before_action :ensure_current_user_is_question_author!, only: %i[choose_best]

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question = question
    @answer.save
  end

  def update
    answer.update(answer_params)
    @question = answer.question
  end

  def destroy
    answer.destroy
  end

  def choose_best
    answer.update_to_best!
    @question = answer.question
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end

  def question
    @question ||= Question.with_attached_files.find(params[:question_id])
  end

  helper_method :answer, :question

  def answer_params
    params.require(:answer).permit(
      :body, files: [], links_attributes: %i[id name url _destroy]
    )
  end

  def ensure_current_user_is_answer_author!
    return if current_user.author_of?(answer)

    redirect_to root_path, notice: t('.wrong_author')
  end

  def ensure_current_user_is_question_author!
    return if current_user.author_of?(answer.question)

    redirect_to root_path, notice: t('.wrong_author')
  end
end
