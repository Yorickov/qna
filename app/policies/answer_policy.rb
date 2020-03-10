class AnswerPolicy < ApplicationPolicy
  include VotedPolicy

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user.present?
  end

  def update?
    create? && (admin? || author?)
  end

  def destroy?
    update?
  end

  def choose_best?
    create? && record.question.user == user
  end
end
