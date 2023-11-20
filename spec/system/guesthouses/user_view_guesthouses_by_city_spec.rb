require 'rails_helper'

RSpec.describe 'User view active guesthouses list by city', type: :system do
  it 'in alphabetical order' do
    # Arrange
    ['Z Pousada', 'A Pousada', 'M Pousada', 'Pousada Inativa'].each_with_index do |name, index|
      user = User.create!(
        email: "host#{index}@cidadea.com", password: 'password', 
        name: "Host #{index}", role: :host
      )

      Guesthouse.create!(
        brand_name: name, corporate_name: "Corporate #{name}", tax_code: "123456789#{index}", 
        phone: "12345678#{index}", email: "contact@pousada#{index}.com", address: "Rua #{index}, 1",
        district: "Bairro #{index}", state: "Estado #{index}", city: 'Cidade A', postal_code: "12345-67#{index}", 
        description: "Descrição de #{name}", accepts_pets: true, active: index != 3, 
        usage_policy: "Uso permitido", check_in: Time.now, check_out: Time.now, user: user
      )
    end

    # Act
    visit city_guesthouses_path('cidade-a')

    # Assert
    expect(page).to have_selector('div.guesthouse-listing', count: 3)
    expect(page).to have_content 'A Pousada'
    expect(page).to have_content 'M Pousada'
    expect(page).to have_content 'Z Pousada'
    expect(page).not_to have_content 'Pousada Inativa'
    expect(page.body.index('A Pousada')).to be < page.body.index('M Pousada')
    expect(page.body.index('M Pousada')).to be < page.body.index('Z Pousada')
  end

  it 'and sees its details' do
    # Arrange
    host = User.create!(name: 'Andre', email: 'andre@email.com', password: 'password', role: 8)

    guesthouse = Guesthouse.create!(
      brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
      email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
      postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
      usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user: host
    )

    # Act
    visit city_guesthouses_path('campo-verde')
    click_on('Cantinho no mato')

    # Assert  
    expect(current_path).to eq guesthouse_path(guesthouse)
    expect(page).to have_content 'Nome: Cantinho no mato'
  end

  
end