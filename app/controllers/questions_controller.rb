class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show destroy]
  before_action :ensure_current_user_is_question_author!, only: %i[destroy]

  def index
    @questions = Question.all
  end

  def new
    @question = current_user.questions.new
  end

  def show; end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: t('.success')
    else
      render :new
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: t('.success')
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def ensure_current_user_is_question_author!
    return if current_user.author_of?(@question)

    redirect_to root_path, notice: t('.wrong_author')
  end
end
