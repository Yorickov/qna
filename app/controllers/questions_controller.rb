class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show destroy update]
  before_action :load_subscription, only: %i[show update]

  after_action :publish_question, only: :create

  def index
    @questions = Question.with_attached_files.all
  end

  def new
    authorize Question
    @question = current_user.questions.new
  end

  def show
    @answer = Answer.new
    gon.question_id = @question.id
    gon.question_author_id = @question.user_id
  end

  def create
    authorize Question

    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: t('.success')
    else
      render :new
    end
  end

  def update
    authorize @question

    @question.update(question_params)
  end

  def destroy
    authorize @question

    @question.destroy
    redirect_to questions_path, notice: t('.success')
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def load_subscription
    @subscription = @question.subscriptions.find_by(user: current_user)
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
