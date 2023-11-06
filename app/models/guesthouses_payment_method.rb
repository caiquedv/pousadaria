class GuesthousesPaymentMethod < ApplicationRecord
  belongs_to :guesthouse
  belongs_to :payment_method
end
