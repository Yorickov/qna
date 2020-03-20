class QuestionPolicy < ApplicationPolicy
  include VotedPolicy

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user.present?
  end

  def new?
    create?
  end

  def update?
    create? && (admin? || author?)
  end

  def destroy?
    update?
  end

  def subscribe?
    user.present? && !subscriber?
  end

  def unsubscribe?
    user.present? && subscriber?
  end

  private

  def subscriber?
    user.subscribed_questions.exists?(record.id)
  end
end
