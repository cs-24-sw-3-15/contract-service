class ContractPolicy < ApplicationPolicy
  def show?
    return true if @user.privileged?
    return true if @record.created_by == @user

    false
  end

  def new?
    true
  end

  def create?
    return true if @user.privileged?
    return true if @record.created_by == @user

    false
  end

  def destroy?
    return true if @user.privileged?

    false
  end

  # for contracts/id/approve
  def approve?
    return true if @user.privileged?

    false
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if @user.privileged?
        scope.all
      else
        scope.where(created_by: @user)
      end
    end
  end
end
