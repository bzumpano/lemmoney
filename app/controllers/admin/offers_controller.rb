class Admin::OffersController < AdminController

  PERMITTED_PARAMS = %i[
    advertiser_name
    url
    description
    starts_at
    ends_at
    premium
  ]

  # helper methods

  helper_method :offers, :offer


  # actions

  def index
  end

  def new
  end

  def create
    if offer.save
      flash[:notice] = t('.done')
      redirect_to admin_offers_path
    else
      flash.now[:alert] = t('.error')
      render :new
    end
  end

  def edit
  end

  def update
    offer.assign_attributes(resource_params) if resource_params.present?

    if offer.save
      flash[:notice] = t('.done')
      redirect_to admin_offers_path
    else
      flash.now[:alert] = t('.error')
      render :edit
    end
  end

  def destroy
    if offer.destroy
      flash[:notice] = t('.done')
      redirect_to admin_offers_path
    else
      flash[:notice] = t('.error')
      redirect_to admin_offers_path
    end
  end

  private

  def offers
    @offers ||= Offer.all
  end

  def offer
    @offer ||= find_action? ? Offer.find(params[:id]) : offers.new(resource_params)
  end

  def resource_params
    params.require(:offer).permit(*PERMITTED_PARAMS) if params[:offer]
  end

  def find_action?
    %w[edit update destroy].include?(action_name)
  end
end
