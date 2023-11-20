class Room < ApplicationRecord
  belongs_to :guesthouse
  has_many :seasonal_rates, dependent: :destroy

  has_many :reservations

  scope :all_active, -> { where(active: true) }
end
