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
end
