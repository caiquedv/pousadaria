require 'rails_helper'

RSpec.describe PaymentMethod, type: :model do
  
  describe '#valid?' do
    it 'false when name is empty' do
      payment_method = PaymentMethod.new(name: '')

      expect(payment_method).not_to be_valid
    end
  end
  
end
