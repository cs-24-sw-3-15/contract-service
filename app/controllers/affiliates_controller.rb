class AffiliatesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_affiliate, except: :index

  def index
    @affiliates = policy_scope(Affiliate)
  end

  def new
    @affiliate = Affiliate.new
  end

  def create
    @affiliate = Affiliate.new(affiliate_params)
    if @affiliate.save
      redirect_to affiliates_path, notice: 'Affiliate was successfully created.'
    else
      render :new
    end
  end

  private

  def authorize_affiliate
    authorize @affiliate || Affiliate
  end

  def set_affiliate
    @affiliate = Affiliate.find(params[:id])
  end

  def affiliate_params
    params.require(:affiliate).permit(:name, :stake)
  end
end
