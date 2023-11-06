require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#description' do
    it 'shows name, email and role' do
      # Arrange
      f_user = User.new(name: 'Caique Andrade', email: 'caique@email.com', role: 4)
      s_user = User.new(name: 'Erika Campos', email: 'erika@email.com', role: 8)
      
      # Act
      
      # Assert
      expect(f_user.description).to eq('Caique Andrade - caique@email.com - Hóspede')
      expect(s_user.description).to eq('Erika Campos - erika@email.com - Anfitrião')
    end
  end

  describe '#valid?' do
    it 'name, email and password are mandatory' do 
      user = User.new(name: '', email: '', password: '')

      user.valid?

      expect(user.errors.include? :name).to eq true
      expect(user.errors.include? :password).to eq true
      expect(user.errors.include? :email).to eq true
    end
  end

  describe '#set_default_role' do
    it 'empty role is saved as guest' do       
      user = User.create!(role: '', name: 'Erika Campos', email: 'erika@email.com', password: 'password')      

      expect(user.role).to eq 'guest'
    end
  end

  context 'associations' do
    it 'can have one guesthouse' do 
      # Arrange
      host = User.create!(name: 'Erika', email: 'erika@email.com', password: 'password', role: 8)

      first_guesthouse = Guesthouse.create!(
        brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
        email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
        postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
        usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user: host
      )
  
      second_guesthouse = Guesthouse.new(
        brand_name: 'Resort Azul', corporate_name: 'Resort Hotel', tax_code: '17.514.160/0001-51', phone: '11 8888',
        email: 'azul@pousada.com', address: 'Rua do resort, 20', district: 'Bairro do resort', state: 'MT', city: 'Chapada dos Guimarães',
        postal_code: '80000-000', description: 'Um resort cheio de piscinas', accepts_pets: false, active: false,
        usage_policy: 'Proíbido não se divertir', check_in: '13:00', check_out: '11:00', user: host
      )

      # Act

      # Assert
      expect(first_guesthouse.id).not_to be_nil
      expect { second_guesthouse.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'is associated with the guesthouse' do 
      # Arrange
      host = User.create!(name: 'Erika', email: 'erika@email.com', password: 'password', role: 8)

      host.build_guesthouse(
        brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
        email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
        postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
        usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00'
      ).save
      
      # Act
      guesthouse = Guesthouse.last

      # Assert
      expect(host.guesthouse).to eq(guesthouse)

    end
  end 
end
