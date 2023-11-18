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
        usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user: host
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

  it 'by clicking on its name on the home screen' do
    user = User.create!(email: 'host@example.com', password: 'password', name: 'Host', role: :host)

    guesthouse = Guesthouse.create!(
      brand_name: 'Pousada Teste', corporate_name: 'Corporate Teste', tax_code: '00.000.000/0001-00',
      phone: '11 99999-0000', email: 'pousada@example.com', address: 'Endereço Teste',
      district: 'Bairro Teste', state: 'Estado Teste', city: 'Cidade Teste', postal_code: '00000-000',
      description: 'Descrição da Pousada Teste', accepts_pets: true, active: true, usage_policy: 'Política de Uso Teste',
      check_in: Time.now, check_out: Time.now, user: user
    )

    visit root_path
    click_on 'Pousada Teste'
    expect(current_path).to eq guesthouse_path(guesthouse)
    expect(page).to have_content 'Pousada Teste'
    expect(page).to have_content 'Descrição da Pousada Teste'
    expect(page).to have_content 'Cidade Teste'
    expect(page).not_to have_content guesthouse.corporate_name
    expect(page).not_to have_content guesthouse.tax_code
  end

  it 'and sees a list of only active rooms and their details except seasonal prices' do 
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
      dimension: 40, capacity: 5, daily_rate: 200, bathroom: true, balcony: true, air_conditioning: true, 
      television: true, closet: true, safe: true, accessibility: true, guesthouse: guesthouse, active: true
    )

    inactive_room = Room.create!(
      name: 'Ruby', description: 'Quarto médio com uma cama de casal', 
      dimension: 30, capacity: 2, daily_rate: 150, bathroom: false, balcony: false, air_conditioning: false, 
      television: false, closet: false, safe: false, accessibility: false, guesthouse: guesthouse, active: false
    )

    # Act 
    login_as host
    visit guesthouse_path(guesthouse.id)

    # Assert
    within('h3') { expect(page).to have_content 'Quartos disponíveis' }
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
    expect(page).not_to have_content 'Quarto Ruby'
    expect(page).not_to have_content 'Descrição: Quarto médio com uma cama de casal'
    expect(page).not_to have_content 'Capacidade: 2 pessoas'
    expect(page).not_to have_content 'Valor da diária: R$ 150.0'
  end

end
