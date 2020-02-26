class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :ensure_current_user_is_question_author!, only: %i[update destroy]

  def index
    @questions = Question.all
  end

  def new
    @question = current_user.questions.new
    @question.build_award
  end

  def show
    @answer = Answer.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: t('.success')
    else
      render :new
    end
  end

  def update
    question.update(question_params)
  end

  def destroy
    question.destroy
    redirect_to questions_path, notice: t('.success')
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(
      :title, :body, files: [],
                     links_attributes: %i[id name url _destroy],
                     award_attributes: %i[id title image _destroy]
    )
  end

  def ensure_current_user_is_question_author!
    return if current_user.author_of?(question)

    redirect_to root_path, notice: t('.wrong_author')
  end
end
