class Guesthouse < ApplicationRecord
  has_many :guesthouses_payment_methods
  has_many :payment_methods, through: :guesthouses_payment_methods
  has_many :rooms, dependent: :destroy
  belongs_to :user

  validates :user_id, uniqueness: true
  validates :accepts_pets, :active, inclusion: { in: [true, false] }
  validates :brand_name, :corporate_name, :tax_code, :phone, :email, :address, 
            :district, :state, :city, :postal_code, :description, 
            :check_in, :check_out, presence: true

  scope :all_active, -> { where(active: true) }

  def formatted_check_in
    self.check_in.strftime('%H:%M') if self.check_in
  end

  def formatted_check_out
    self.check_out.strftime('%H:%M') if self.check_out
  end

  def handle_accepts_pets
    return 'Aceita pets' if self.accepts_pets

    'Não aceita pets'
  end
end
