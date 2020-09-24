class OffersController < ApplicationController

  # helper methods

  helper_method :offers


  # actions

  def index
  end

  private

  def offers
    @offers ||= paginated_offers
  end

  def visible_offers
    Offer.enabled.where('starts_at <= :current_date AND ends_at IS NULL', current_date: Time.zone.now).or(
      Offer.enabled.where(':current_date BETWEEN starts_at AND ends_at', current_date: Time.zone.now)
    )
  end

  def sorted_offers
    visible_offers.order(premium: :desc)
  end

  def paginated_offers
    sorted_offers.page(params[:page])
  end
end
