class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = commentable.comments.new(comment_params.merge(user: current_user))
    @comment.save
  end

  private

  def commentable
    klass = [Question, Answer].find { |k| params["#{k.name.underscore}_id"] }
    klass.find(params["#{klass.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
