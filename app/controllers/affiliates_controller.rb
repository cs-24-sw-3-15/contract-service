class AffiliatesController < ApplicationController
  before_action :authenticate_user!

  def index
    @affiliates = policy_scope(Affiliate)
  end

  def new
    @affiliate = authorize Affiliate.new
  end

  def create
    @affiliate = authorize Affiliate.new(affiliate_params)
    if @affiliate.save
      redirect_to affiliates_path, notice: 'Affiliate was successfully created.'
    else
      render :new
    end
  end

  private

  def affiliate_params
    params.require(:affiliate).permit(:name, :stake)
  end
end
