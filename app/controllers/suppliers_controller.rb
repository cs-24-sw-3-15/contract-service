class SuppliersController < ApplicationController
  before_action :authenticate_user!

  def index
    @suppliers = policy_scope(Supplier)
  end

  def new
    @supplier = authorize Supplier.new
  end

  def create
    @supplier = authorize Supplier.new(supplier_params)
    if @supplier.save
      redirect_to suppliers_path, notice: 'Supplier was successfully created.'
    else
      render :new
    end
  end

  private

  def supplier_params
    params.require(:supplier).permit(:name, :supplier_number)
  end
end
