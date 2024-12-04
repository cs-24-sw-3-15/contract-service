class ContractsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_policy_scoped, only: :pending
  after_action :verify_authorized, only: :approve

  def index
    @contracts = policy_scope(Contract)
  end

  def show
    @contract = authorize Contract.find(params["id"])
  end

  def new
    @contract = authorize Contract.new(documents_attributes: [ {} ])
    @labels = policy_scope(Label).order(:tag).map { [ _1.stamp, _1.id ] }
  end

  def create
    @contract = Contract.new(contract_params)

    @contract.created_by = current_user
    @contract.documents.each do |document|
      document.created_by = current_user
      document.title ||= File.basename(document.file.filename.to_s, ".*").titleize
    end

    authorize @contract

    if @contract.save
      redirect_to contracts_path, notice: "Contract successfully submitted."
    else
      @labels = policy_scope(Label).order(:tag).map { [ _1.stamp, _1.id ] }
      render :new, status: 422
    end
  end

  def destroy
    @contract = authorize Contract.find(params["id"])
    @contract.destroy
    redirect_to contracts_path
  end

  def pending
    authorize Contract
    @contracts = policy_scope(Contract).where(status: :pending)
  end

  def approve
    @contract = authorize Contract.find(params["id"])
    @suppliers = policy_scope(Supplier)
    @affiliates = policy_scope(Affiliate)
    @labels = policy_scope(Label).order(:tag).map { [ _1.stamp, _1.id ] }

    if request.patch?
      if @contract.update(contract_privileged_params.merge(status: :approved))
        redirect_to contracts_pending_path, notice: "Contract was successfully approved."
      else
        render :approve, status: 422
      end
    else
      render :approve
    end
  end

  private

  def contract_params
    params.require(:contract).permit(
      :title,
      documents_attributes: [ [ :file ] ]
    )
  end

  def contract_privileged_params
    params.require(:contract).permit(
      :supplier_id,
      :affiliate_id,
      :start_date,
      :end_date,
      :title,
      :label_id,
      documents_attributes: [ [ :file ] ]
    )
  end
end
