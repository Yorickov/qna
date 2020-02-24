module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: %i[vote_up vote_down vote_reset]
  end

  def vote_up
    render_errors and return if current_user.author_of?(@votable)

    @votable.update_vote_up(current_user)
    render_json
  end

  def vote_down
    render_errors and return if current_user.author_of?(@votable)

    @votable.update_vote_down(current_user)
    render_json
  end

  def vote_reset
    render_errors and return if current_user.author_of?(@votable)

    @votable.update_vote_reset(current_user)
    render_json
  end

  private

  def load_votable
    @votable = model_klass.find(params[:id])
  end

  def render_json
    render json: { id: @votable.id, name: param_name(@votable), rating: @votable.rating }
  end

  def render_errors
    render json: { message: t('.message') }, status: :forbidden
  end

  def param_name(item)
    item.class.name.underscore
  end

  def model_klass
    controller_name.classify.constantize
  end
end
