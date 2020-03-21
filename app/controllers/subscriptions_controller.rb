class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    authorize @question, :subscribe?

    @subscription = current_user.subscriptions.create!(question: @question)
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    authorize @subscription.question, :unsubscribe?

    @subscription.destroy
  end
end
