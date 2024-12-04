class ContractsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_policy_scoped, only: :pending

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
      redirect_to contracts_path, notice: "Contract successfully submitted."
    else
      @labels = policy_scope(Label).order(:tag).map { [ _1.stamp, _1.id ] }
      render :new
    end
  end

  def destroy
    @contract = authorize Contract.find(params["id"])
    @contract.destroy
    redirect_to contracts_path
  end

  def pending
    @contracts = policy_scope(Contract).where(status: :pending)
    # authorize :contract, :pending?
  end

  def approve
    @contract = authorize Contract.find(params["id"])
    @suppliers = policy_scope(Supplier)
    @affiliates = policy_scope(Affiliate)
    @labels = policy_scope(Label).order(:tag).map { [ _1.stamp, _1.id ] }

    if request.patch?
      if @contract.update(contract_params.except(:documents_attributes).merge(status: :approved))
        puts "Contract approved"
        redirect_to contracts_pending_path, notice: "Contract was successfully approved."
      else
        puts @contract.errors.full_messages
        render :approve
      end
    else
      render :approve
    end
  end

  private
  def contract_params
    params.require(:contract).permit(
      :label_id,
      :supplier_id,
      :affiliate_id,
      :start_date,
      :end_date,
      :title,
      :label_id,
      documents_attributes: [ [ :title, :file ] ]
    )
  end
end
