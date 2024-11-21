class ContractsController < ApplicationController
  before_action :authenticate_user!

  def index
    # if admin? then all, otherwise only contracts made by that user.
    @contracts = policy_scope(Contract)
  end

  def show
    @contract = authorize Contract.find(params["id"])
  end

  def new
    # HACK: Hardcoding one empty "document" to allow view to function.
    @contract = authorize Contract.new(documents_attributes: [ {} ])
  end

  def create
    @contract = Contract.new(contract_params)

    @contract.created_by = current_user
    @contract.documents.each { |doc| doc.created_by = current_user }

    authorize @contract

    if @contract.save
      redirect_to contracts_path, notice: "Contract successfully created."
    else
      render :new
    end
  end

  def destroy
    @contract = authorize Contract.find(params["id"])
    @contract.destroy
    redirect_to contracts_path
  end

  private
  def contract_params
    params.require(:contract).permit(
      :title,
      documents_attributes: [ [ :title, :file ] ]
    )
  end
end
