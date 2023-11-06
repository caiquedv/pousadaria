require 'rails_helper'

describe 'User visits home page' do 
  it 'and sees the app name as title linking to home' do 
    # Arrange

    # Act        
    visit ('/')

    # Assert
    within('h1') { expect(page).to have_link('InnSight', href: root_path) }
  end

  context 'when guest' do
    it "and don't sees a link to my_guesthouse" do 
      guest = User.create!(name: 'Andre', email: 'andre@email.com', password: 'password', role: 4)

      login_as guest
      visit root_path

      expect(page).not_to have_content 'Minha Pousada'
    end
  end

  it 'and sees a list of only active guesthouses' do 
    # Arrange
    first_host = User.create!(name: 'Andre', email: 'andre@email.com', password: 'password', role: 8)
    second_host = User.create!(name: 'Erika', email: 'erika@email.com', password: 'password', role: 8)

    first_guesthouse = Guesthouse.create!(
      brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
      email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
      postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
      usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user: first_host
    )

    second_guesthouse = Guesthouse.create!(
      brand_name: 'Resort Azul', corporate_name: 'Resort Hotel', tax_code: '17.514.160/0001-51', phone: '11 8888',
      email: 'azul@pousada.com', address: 'Rua do resort, 20', district: 'Bairro do resort', state: 'MT', city: 'Chapada dos Guimarães',
      postal_code: '80000-000', description: 'Um resort cheio de piscinas', accepts_pets: false, active: false,
      usage_policy: 'Proíbido não se divertir', check_in: '13:00', check_out: '11:00', user: second_host
    )

    # Act 
    visit root_path

    # Assert
    within('h2') { expect(page).to have_content 'Pousadas' }
    expect(page).to have_content 'Nome: Cantinho no mato'
    expect(page).to have_content 'Local: Campo Verde - MT'
    expect(page).to have_content 'Descrição: Uma pousada no meio do mato'
    expect(page).not_to have_content 'Nome: Resort Azul'
    expect(page).not_to have_content 'Local: Chapada dos Guimarães - MT'
    expect(page).not_to have_content 'Descrição: Um resort cheio de piscinas'
  end
end