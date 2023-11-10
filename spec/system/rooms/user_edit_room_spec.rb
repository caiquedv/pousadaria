require 'rails_helper'

describe 'User edit a room' do
  it 'from details screen' do
    # Arrange
    host = User.create!(name: 'Andre', email: 'andre@email.com', password: 'password', role: 8)

    guesthouse = Guesthouse.create!(
      brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
      email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
      postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
      usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user: host
    )

    room = Room.create!(
      name: 'Diamante', description: 'Quarto grande com duas camas de casal e uma de solteiro', 
      dimension: 40, capacity: 5, daily_rate: 20, bathroom: true, balcony: true, air_conditioning: true, 
      television: true, closet: true, safe: true, accessibility: true, guesthouse: guesthouse
    )

    # Act
    login_as host
    visit guesthouse_room_path(guesthouse.id, room.id)
    click_on 'Editar'
    fill_in 'Nome', with: 'Ruby'
    fill_in 'Valor da diária', with: 500
    select 'Não', from: 'Banheiro'
    click_on 'Salvar'

    # Assert
    expect(current_path).to eq guesthouse_room_path(guesthouse.id, room.id)
    expect(page).to have_content 'Quarto atualizado com sucesso'
    expect(page).to have_content 'Nome: Ruby'
    expect(page).to have_content 'Valor da diária: R$ 500.0'
    expect(page).to have_content 'Banheiro: Não'
  end

  it 'only if user is the owner' do 
    # Arrange
    first_host = User.create!(name: 'Andre', email: 'andre@email.com', password: 'password', role: 8)
    second_host = User.create!(name: 'Erika', email: 'erika@email.com', password: 'password', role: 8)

    guesthouse = Guesthouse.create!(
      brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
      email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
      postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
      usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user: first_host
    )

    Guesthouse.create!(
      brand_name: 'Resort Azul', corporate_name: 'Resort Hotel', tax_code: '17.514.160/0001-51', phone: '11 8888',
      email: 'azul@pousada.com', address: 'Rua do resort, 20', district: 'Bairro do resort', state: 'MT', city: 'Chapada dos Guimarães',
      postal_code: '80000-000', description: 'Um resort cheio de piscinas', accepts_pets: false, active: false,
      usage_policy: 'Proíbido não se divertir', check_in: '13:00', check_out: '11:00', user: second_host
    )

    room = Room.create!(
      name: 'Diamante', description: 'Quarto grande com duas camas de casal e uma de solteiro', 
      dimension: 40, capacity: 5, daily_rate: 20, bathroom: true, balcony: true, air_conditioning: true, 
      television: true, closet: true, safe: true, accessibility: true, guesthouse: guesthouse
    )

    # Act
    login_as(second_host)
    visit edit_room_path(room.id)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content('Você não tem permissão para realizar essa ação.')
  end
end
