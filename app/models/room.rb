class Room < ApplicationRecord
  belongs_to :guesthouse

  scope :all_active, -> { where(active: true) }
end
