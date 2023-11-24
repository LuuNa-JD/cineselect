class FavoritePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    !user.nil?
  end

  def destroy?
    user == record.user
  end
end
