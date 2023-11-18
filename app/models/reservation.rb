class Reservation < ApplicationRecord
  belongs_to :room

  validates :start_date, :end_date, :guests_number, presence: true
  validate :check_capacity
  validate :check_availability
  

  enum status: { active: 0, pending: 1, cancelled: 2 }

  def process_reservation
    if valid?
      calculate_total_price
    end
  end

  private

  def check_capacity    
    self.guests_number = 0 if self.guests_number.nil?
    errors.add(:base, 'O quarto não suporta a quantidade de hóspedes.') if self.guests_number > self.room.capacity
  end

  def check_availability
    overlapping_reservations = Reservation.where(room_id: self.room_id)
                              .where.not(status: :cancelled)
                              .where('start_date < ? AND end_date > ?', self.end_date, self.start_date)

    errors.add(:base, 'O quarto não está disponível para o período selecionado.') if overlapping_reservations.any?
  end

  def calculate_total_price
    total_price = 0

    (start_date..end_date).each do |date|
      daily_rate = room.daily_rate
  
      seasonal_rate = room.seasonal_rates.find do |s_rate|
        date.between?(s_rate.start_date, s_rate.end_date)
      end
  
      daily_rate = seasonal_rate.daily_rate if seasonal_rate.present?
  
      total_price += daily_rate
    end
  
    self.total_price = total_price
  end

end
