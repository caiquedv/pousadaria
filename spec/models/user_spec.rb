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
end
