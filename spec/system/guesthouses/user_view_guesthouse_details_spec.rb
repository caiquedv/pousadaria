require 'rails_helper'

describe 'User view guesthouse details' do
  context 'when host' do  
    it 'through the my_guesthouse link on the home screen' do 
      # Arrange
      host = User.create!(name: 'Andre', email: 'andre@email.com', password: 'password', role: 8)
  
      guesthouse = Guesthouse.create!(
        brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
        email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
        postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
        usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user_id: host.id
      )

      # Act 
      login_as host 
      visit root_path
      click_on 'Minha Pousada'

      # Assert
      expect(current_path).to eq guesthouse_path(guesthouse)
      within('h2') { expect(page).to have_content 'Detalhes da Pousada' } 
      expect(page).to have_content 'Nome: Cantinho no mato'
      expect(page).to have_content 'Descrição: Uma pousada no meio do mato'
      expect(page).to have_content 'Local: Campo Verde - MT'
      expect(page).to have_content 'Aceita pets'
      expect(page).to have_content 'Check In: 14:00'
      expect(page).to have_content 'Check Out: 12:00'
    end
  end
  

end
