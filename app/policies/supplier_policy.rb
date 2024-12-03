class SupplierPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if @user.privileged?
        scope.all
      else
        scope.none
      end
    end
  end

  def index?
    @user.privileged?
  end

  def new?
    create?
  end

  def create?
    @user.privileged?
  end
end
