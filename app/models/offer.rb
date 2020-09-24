class Offer < ApplicationRecord

  # Enums

  enum status: %i[disabled enabled]


  #  Validations

  ## Presence

  validates :advertiser_name,
    :url,
    :description,
    :starts_at,
    presence: true

  ## Uniqueness

  validates :advertiser_name,
    uniqueness: true

  ## URL

  validates :url,
    url: true

  ## Length

  validates_length_of :description, maximum: 500
end
