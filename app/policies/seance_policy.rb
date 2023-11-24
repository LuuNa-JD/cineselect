class SeancePolicy < ApplicationPolicy
  class Scope < Scope

    def default_action?
      true
    end

    def resolve
      scope.all
    end
  end

  def new?
    true
  end

  def create?
    true
  end


  def index?
    true
  end

  def show?
    true
  end

  def show_streaming_platforms?
    true
  end

  def search?
    true
  end
end
