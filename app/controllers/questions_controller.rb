class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show destroy update]

  after_action :publish_question, only: :create

  authorize_resource

  def index
    @questions = Question.all
  end

  def new
    @question = current_user.questions.new
  end

  def show
    @answer = Answer.new
    gon.question_id = @question.id
    gon.question_author_id = @question.user_id
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
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: t('.success')
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(
      :title, :body, files: [],
                     links_attributes: %i[id name url _destroy],
                     award_attributes: %i[id title image _destroy]
    )
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end
end
