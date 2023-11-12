class SeasonalRate < ApplicationRecord
  belongs_to :room 
  validate :no_date_overlap

  private

  def no_date_overlap
    overlaps = SeasonalRate.where(room_id: room_id)
                           .where('start_date < ? AND end_date > ?', end_date, start_date)
                           .or(
                            SeasonalRate.where(room_id: room_id)
                                        .where('start_date > ? AND end_date < ?', start_date, end_date)
                           )

    if overlaps.exists?                           
      errors.add(:base, 'Não é possível sobrepor datas.')
    end
  end
end
