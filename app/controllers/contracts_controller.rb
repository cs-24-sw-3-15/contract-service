class ContractsController < ApplicationController
  def index
    @contracts = Contract.all
  end
  def show
    @contract = Contract.find(params["id"])
  end
  def new
    # HACK: Hardcoding one empty "document" to allow view to function.
    @contract = Contract.new(documents_attributes: [ {} ])
  end
  def create
    @contract = Contract.new(contract_params)
    if @contract.save
      redirect_to contracts_path
    else
      render :new
    end
  end
  def destroy
    Contract.find(params["id"]).destroy
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
