class FavoritePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def toggle?
    !user.nil?
  end

  def create?
    !user.nil?
  end

  def destroy?
    record.user == user
  end
end
