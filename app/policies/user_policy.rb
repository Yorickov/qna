class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def me?
    user.present?
  end

  def index?
    me? && admin?
  end
end
