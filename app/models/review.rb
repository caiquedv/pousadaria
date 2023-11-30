class Review < ApplicationRecord
  belongs_to :reservation

  def self.average_rating_for_guesthouse(guesthouse_id)
    rating = joins(reservation: { room: :guesthouse })
      .where(rooms: { guesthouse_id: guesthouse_id })
      .where.not(rate: nil)
      .average(:rate)
      
      rating ? rating.round(0) : ''
  end
  
end
