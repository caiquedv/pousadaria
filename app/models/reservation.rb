class Reservation < ApplicationRecord
  belongs_to :room
  belongs_to :user, optional: true
  belongs_to :payment_method, optional: true
  
  has_one :guesthouse, through: :room

  has_many :reviews

  validates :start_date, :end_date, :guests_number, presence: true
  validate :check_capacity, :check_availability
  validate :end_date_after_start_date, :start_date_after_today, on: :create

  before_validation :geneate_code, on: :create 
  
  enum status: { active: 0, pending: 1, cancelled: 2, finished: 3 }
  
  attr_accessor :is_available

  def process_reservation
    if valid? 
      calculate_total_price
      self.is_available = true              
    end
  end

  def finish_reservation
    calculate_total_due
  end

  private

  def check_availability
    overlapping_reservations = Reservation.where(room_id: room_id)
                              .where.not(id: id)
                              .where.not(status: :cancelled)
                              .where('start_date < ? AND end_date > ?', end_date, start_date)

    errors.add(:base, 'O quarto não está disponível para o período selecionado.') if overlapping_reservations.any?
  end

  def check_capacity    
    return if guests_number.nil?

    errors.add(:base, 'O quarto não suporta a quantidade de hóspedes.') if guests_number > room.capacity
  end

  def end_date_after_start_date
    return if start_date.blank? || end_date.blank?

    errors.add(:end_date, 'deve ser maior que a data inicial.') if start_date >= end_date 
  end
 
  def start_date_after_today
    return if start_date.blank?

    errors.add(:start_date, 'deve ser maior que a data atual.') if start_date < Date.today
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

  def calculate_total_due
    total_due = 0
    start_date = checked_in_at.to_date
    end_date = checked_out_at.present? ? checked_out_at.to_date : Time.zone.now.to_date
  
    (start_date...end_date).each do |date|
      daily_rate = room.daily_rate
  
      seasonal_rate = room.seasonal_rates.find do |s_rate|
        date.between?(s_rate.start_date, s_rate.end_date)
      end
  
      daily_rate = seasonal_rate.daily_rate if seasonal_rate.present?
      total_due += daily_rate
    end
  
    if checked_out_at.present? && checked_out_at.time > guesthouse.check_out
      total_due += room.daily_rate
    end
  
    total_due
  end
  

  def geneate_code
    self.code = SecureRandom.alphanumeric(8).upcase
  end
end
