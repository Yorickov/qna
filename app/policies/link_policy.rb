class LinkPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def destroy?
    # user = user
    user.present? && (admin? || record.linkable.user == user)
  end
end
