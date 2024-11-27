class SupplierPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin? || user.legal?
        scope.all
      else
        scope.none
      end
    end
  end

  def index?
    user.admin? || user.legal?
  end

  def new?
    user.admin? || user.legal?
  end

  def create?
    user.admin? || user.legal?
  end
end
