require 'rails_helper'

describe 'User defines a daily rate for the season' do
  it 'successfully from room details screen' do
    # Arrange
    user = User.create!(name: 'João', email: 'joao@email.com', password: 'password', role: 8)
    
    guesthouse = Guesthouse.create!(
      brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
      email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
      postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
      usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user: user
    )

    room = Room.create!(
      name: 'Diamante', description: 'Quarto grande com duas camas de casal e uma de solteiro', 
      dimension: 40, capacity: 5, daily_rate: 200, bathroom: true, balcony: true, air_conditioning: true, 
      television: true, closet: true, safe: true, accessibility: true, guesthouse: guesthouse
    )

    # Act
    login_as user
    visit guesthouse_room_path(guesthouse.id, room.id)
    click_on 'Adicionar preço'
    fill_in 'Descrição', with: 'Fim de ano'
    fill_in 'Data Inicial', with: '10/12/2023'
    fill_in 'Data Final', with: '05/01/2023'
    fill_in 'Valor da diária', with: '400'
    click_on 'Salvar'

    # Assert
    expect(current_path).to eq guesthouse_room_path(guesthouse.id, room.id)
    expect(page).to have_content 'Preço adicionado com sucesso.'
    expect(page).to have_content 'Descrição: Fim de ano | de 10/12/2023 até 05/01/2023 | R$ 200.0'
  end

  it "and don't overlap dates" do 
    # Arrange
    user = User.create!(name: 'João', email: 'joao@email.com', password: 'password', role: 8)
    
    guesthouse = Guesthouse.create!(
      brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
      email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
      postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
      usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user: user
    )

    room = Room.create!(
      name: 'Diamante', description: 'Quarto grande com duas camas de casal e uma de solteiro', 
      dimension: 40, capacity: 5, daily_rate: 200, bathroom: true, balcony: true, air_conditioning: true, 
      television: true, closet: true, safe: true, accessibility: true, guesthouse: guesthouse
    )

    room.seasonal_rates.create!(description: 'Natal', start_date: '20/12/2023', end_date: '28/12/2023', daily_rate: 500)

    # Act
    login_as user
    visit guesthouse_room_path(guesthouse.id, room.id)
    click_on 'Adicionar preço'
    fill_in 'Descrição', with: 'Fim de ano'
    fill_in 'Data Inicial', with: '10/12/2023'
    fill_in 'Data Final', with: '05/01/2024'
    fill_in 'Valor da diária', with: '400'
    click_on 'Salvar'

    # Assert
    expect(SeasonalRate.where(description: 'Fim de ano')).to be_empty
    expect(page).to have_content 'Não é possível sobrepor datas.'
  end
end
