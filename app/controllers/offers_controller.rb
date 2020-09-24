class OffersController < ApplicationController

  # helper methods

  helper_method :offers


  # actions

  def index
  end

  private

  def offers
    @offers ||= Offer.enabled.order(premium: :desc).page(params[:page])
  end
end
