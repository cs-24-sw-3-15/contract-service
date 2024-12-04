class LabelPolicy < ApplicationPolicy
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
    return true if @user.privileged?

    false
  end

  def show?
    return true if @user.privileged?

    false
  end

  def new?
    create?
  end

  def create?
    return true if @user.privileged?

    false
  end

  def destroy?
    return true if @user.privileged?

    false
  end
end
