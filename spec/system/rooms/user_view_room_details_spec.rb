require 'rails_helper'

RSpec.describe 'User views room details', type: :system do
  it 'displays room details excluding seasonal rates' do
    # Arrange
    user = User.create!(email: 'host@example.com', password: 'password', name: 'Host', role: :host)
    guesthouse = Guesthouse.create!(
      brand_name: 'Pousada Teste', corporate_name: 'Pousada Teste Corp', tax_code: '123456789',
      phone: '123456789', email: 'pousadateste@example.com', address: 'Rua Teste, 123',
      district: 'Teste', state: 'Estado', city: 'Cidade', postal_code: '12345-678',
      description: 'Descrição da Pousada', accepts_pets: true, active: true,
      usage_policy: 'Uso permitido', check_in: Time.now, check_out: Time.now, user: user
    )
    room = Room.create!(
      name: 'Quarto Teste', description: 'Descrição do Quarto', dimension: 30, 
      capacity: 4, daily_rate: 150, bathroom: true, balcony: true, air_conditioning: true, 
      television: true, closet: true, safe: true, accessibility: true, guesthouse: guesthouse
    )

    # Act    
    visit guesthouse_room_path(guesthouse.id, room.id)

    # Assert
    expect(page).to have_content room.name
    expect(page).to have_content room.description
    expect(page).to have_content "#{room.dimension} m2"
    expect(page).to have_content "#{room.capacity} pessoas"
    expect(page).to have_content "R$ #{room.daily_rate}"
    expect(page).to have_content 'Sim'
    expect(page).to have_content 'Sim'
    expect(page).to have_content 'Sim'
    expect(page).to have_content 'Sim'
    expect(page).to have_content 'Sim'
    expect(page).to have_content 'Sim'
    expect(page).to have_content 'Sim'
    expect(page).not_to have_content 'Preços por Período'
  end
end
