class ContractsController < ApplicationController
  before_action :authenticate_user!

  def index
    # if admin? then all, otherwise only contracts made by that user.
    @contracts = policy_scope(Contract.where(status: :approved))
  end

  def show
    @contract = authorize Contract.find(params["id"])
  end

  def new
    # HACK: Hardcoding one empty "document" to allow view to function.
    @contract = authorize Contract.new(documents_attributes: [ {} ])
    @labels = policy_scope(Label).order(:tag).map { [ _1.stamp, _1.id ] }
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
    authorize :contract, :pending?
  end

  def approve
    @contract = authorize Contract.find(params["id"])
    @contract.documents.each { |doc| doc.created_by = current_user }

    if request.patch?
      supplier = Supplier.find_by(supplier_number: contract_params[:supplier_number])
      affiliate = Affiliate.find_by(name: contract_params[:affiliate_name])

      if supplier.nil?
        @contract.errors.add(:supplier_number, "Supplier not found")
        render :approve and return
      end

      if affiliate.nil?
        @contract.errors.add(:affiliate_name, "Affiliate not found")
        render :approve and return
      end

      @contract.supplier_id = supplier.id
      @contract.affiliate_id = affiliate.id
      @contract.supplier_number = supplier.supplier_number
      @contract.affiliate_name = affiliate.name
      @contract.start_date = contract_params[:start_date] if contract_params[:start_date].present?
      @contract.end_date = contract_params[:end_date] if contract_params[:end_date].present?
      @contract.status = :approved

      if @contract.save
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
      :supplier_number,
      :affiliate_name,
      :start_date,
      :end_date,
      :title,
      :label_id,
      documents_attributes: [ [ :title, :file ] ]
    )
  end
end
