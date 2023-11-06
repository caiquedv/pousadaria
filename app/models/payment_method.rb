class PaymentMethod < ApplicationRecord
  has_many :guesthouses_payment_methods
  has_many :guesthouses, through: :guesthouses_payment_methods


  validates :name, presence: true
end
