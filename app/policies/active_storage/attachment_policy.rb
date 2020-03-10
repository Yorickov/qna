class ActiveStorage::AttachmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def destroy?
    user.present? && (admin? || user.id == record.record.user_id)
  end
end
