class ContractPolicy < ApplicationPolicy
  def show?
    return true if @user.privileged?
    return true if @record.created_by == @user

    false
  end

  def new?
    create?
  end

  def create?
    true
  end

  def destroy?
    return true if @user.privileged?
    return true if @record.created_by == @user

    false
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if @user.privileged?
        scope.all
      else
        scope.where(created_by: user)
      end
    end
  end
end
