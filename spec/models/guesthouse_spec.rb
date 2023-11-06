require 'rails_helper'

RSpec.describe Guesthouse, type: :model do
  describe '#valid?' do
    let(:user) { User.create!(name: 'João', email: 'joao@email.com', password: 'password', role: 8) }

    let(:valid_attributes) do
      {
        brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
        email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
        postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
        check_in: '14:00', check_out: '12:00'
      }
    end
    
    context 'when required fields are empty' do

      it 'is invalid without a brand name' do
        guesthouse = user.build_guesthouse(valid_attributes.except(:brand_name))
        expect(guesthouse).not_to be_valid
      end

      it 'is invalid without a corporate name' do
        guesthouse = user.build_guesthouse(valid_attributes.except(:corporate_name))
        expect(guesthouse).not_to be_valid
      end

      it 'is invalid without a tax code' do
        guesthouse = user.build_guesthouse(valid_attributes.except(:tax_code))
        expect(guesthouse).not_to be_valid
      end

      it 'is invalid without a phone number' do
        guesthouse = user.build_guesthouse(valid_attributes.except(:phone))
        expect(guesthouse).not_to be_valid
      end

      it 'is invalid without an email' do
        guesthouse = user.build_guesthouse(valid_attributes.except(:email))
        expect(guesthouse).not_to be_valid
      end

      it 'is invalid without an address' do
        guesthouse = user.build_guesthouse(valid_attributes.except(:address))
        expect(guesthouse).not_to be_valid
      end

      it 'is invalid without a district' do
        guesthouse = user.build_guesthouse(valid_attributes.except(:district))
        expect(guesthouse).not_to be_valid
      end

      it 'is invalid without a state' do
        guesthouse = user.build_guesthouse(valid_attributes.except(:state))
        expect(guesthouse).not_to be_valid
      end

      it 'is invalid without a city' do
        guesthouse = user.build_guesthouse(valid_attributes.except(:city))
        expect(guesthouse).not_to be_valid
      end

      it 'is invalid without a postal code' do
        guesthouse = user.build_guesthouse(valid_attributes.except(:postal_code))
        expect(guesthouse).not_to be_valid
      end

      it 'is invalid without a description' do
        guesthouse = user.build_guesthouse(valid_attributes.except(:description))
        expect(guesthouse).not_to be_valid
      end

      it 'is invalid without a check-in time' do
        guesthouse = user.build_guesthouse(valid_attributes.except(:check_in))
        expect(guesthouse).not_to be_valid
      end

      it 'is invalid without a check-out time' do
        guesthouse = user.build_guesthouse(valid_attributes.except(:check_out))
        expect(guesthouse).not_to be_valid
      end
    end

    context 'when boolean fields' do
      it 'is valid when accepts_pets is true' do
        guesthouse = user.build_guesthouse(valid_attributes.merge(accepts_pets: true))
        expect(guesthouse).to be_valid
      end
    
      it 'is valid when accepts_pets is false' do
        guesthouse = user.build_guesthouse(valid_attributes.merge(accepts_pets: false))
        expect(guesthouse).to be_valid
      end
    
      it 'is invalid when accepts_pets is nil' do
        guesthouse = user.build_guesthouse(valid_attributes.merge(accepts_pets: nil))
        expect(guesthouse).not_to be_valid
      end
    
      it 'is valid when active is true' do
        guesthouse = user.build_guesthouse(valid_attributes.merge(active: true))
        expect(guesthouse).to be_valid
      end
    
      it 'is valid when active is false' do
        guesthouse = user.build_guesthouse(valid_attributes.merge(active: false))
        expect(guesthouse).to be_valid
      end
    
      it 'is invalid when active is nil' do
        guesthouse = user.build_guesthouse(valid_attributes.merge(active: nil))
        expect(guesthouse).not_to be_valid
      end
    end
    
  end

  context 'scopes' do
    describe '.all_active' do
      it 'returns only active guesthouses' do
        first_host = User.create!(name: 'Andre', email: 'andre@email.com', password: 'password', role: 8)
        second_host = User.create!(name: 'Erika', email: 'erika@email.com', password: 'password', role: 8)
    
        active_guesthouse = Guesthouse.create!(
          brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
          email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
          postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
          usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user: first_host
        )
    
        inactive_guesthouse = Guesthouse.create!(
          brand_name: 'Resort Azul', corporate_name: 'Resort Hotel', tax_code: '17.514.160/0001-51', phone: '11 8888',
          email: 'azul@pousada.com', address: 'Rua do resort, 20', district: 'Bairro do resort', state: 'MT', city: 'Chapada dos Guimarães',
          postal_code: '80000-000', description: 'Um resort cheio de piscinas', accepts_pets: false, active: false,
          usage_policy: 'Proíbido não se divertir', check_in: '13:00', check_out: '11:00', user: second_host
        )
        
        expect(Guesthouse.all_active).to include(active_guesthouse)
        expect(Guesthouse.all_active).not_to include(inactive_guesthouse)
      end
    end
  end

  context 'instance methods' do
    let(:guesthouse) do     
      Guesthouse.create!(
        brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
        email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
        postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
        usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', 
        user: User.create!(name: 'Erika', email: 'erika@email.com', password: 'password', role: 8)
      )
    end

    describe '#formatted_check_in' do
      it 'returns the check-in time formatted as HH:MM' do
        expect(guesthouse.formatted_check_in).to eq(guesthouse.check_in.strftime('%H:%M'))
      end
    end

    describe '#formatted_check_out' do
      it 'returns the check-out time formatted as HH:MM' do
        expect(guesthouse.formatted_check_out).to eq(guesthouse.check_out.strftime('%H:%M'))
      end
    end

    describe '#handle_accepts_pets' do
      it 'returns "Aceita pets" when accepts_pets is true' do
        expect(guesthouse.handle_accepts_pets).to eq('Aceita pets')
      end

      it 'returns "Não aceita pets" when accepts_pets is false' do
        guesthouse.update(accepts_pets: false)
        expect(guesthouse.handle_accepts_pets).to eq('Não aceita pets')
      end
    end
  end

  context 'associations' do
    it 'belongs to a user' do
      guesthouse = Guesthouse.new
      expect(guesthouse).to respond_to(:user)
    end
  end

end
