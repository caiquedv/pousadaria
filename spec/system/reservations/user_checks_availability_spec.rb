require 'rails_helper'

describe 'User checks availability of room from the guesthouse details screen' do
  it 'and sees room details and the period form' do
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
      television: true, closet: true, safe: true, accessibility: true, guesthouse: guesthouse, active: true
    )

    visit guesthouse_path(guesthouse)
    click_on 'Reservar'

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
    within('form.reservation') do 
      expect(page).to have_field 'Data de Entrada'
      expect(page).to have_field 'Data de Saída'
      expect(page).to have_field 'Quantidade de Hóspedes'
    end
  end

  it 'and there is availability so sees the total price' do
    host = User.create!(name: 'Andre', email: 'andre@email.com', password: 'password', role: 8)

    guesthouse = Guesthouse.create!(
      brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
      email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
      postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
      usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user: host
    )

    room = Room.create!(
      name: 'Ruby', description: 'Quarto grande com duas camas de casal e uma de solteiro', 
      dimension: 40, capacity: 5, daily_rate: 200, bathroom: true, balcony: true, air_conditioning: true, 
      television: true, closet: true, safe: true, accessibility: true, guesthouse: guesthouse, active: true
    )
   
    visit guesthouse_room_path(guesthouse, room)
    fill_in 'Data de Entrada', with: 1.day.from_now
    fill_in 'Data de Saída', with: 5.days.from_now
    fill_in 'Quantidade de Hóspedes', with: 5
    click_on 'Verificar Disponibilidade'
    expect(page).to have_field 'Data de Entrada', with: 1.day.from_now.strftime("%Y-%m-%d")
    expect(page).to have_field 'Data de Saída', with: 5.days.from_now.strftime("%Y-%m-%d")
    expect(page).to have_content 'Total: R$ 1000.0'
  end

  it 'and there is no avalability' do
    host = User.create!(name: 'Andre', email: 'andre@email.com', password: 'password', role: 8)

    guesthouse = Guesthouse.create!(
      brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
      email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
      postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
      usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user: host
    )

    room = Room.create!(
      name: 'Ruby', description: 'Quarto grande com duas camas de casal e uma de solteiro', 
      dimension: 40, capacity: 5, daily_rate: 200, bathroom: true, balcony: true, air_conditioning: true, 
      television: true, closet: true, safe: true, accessibility: true, guesthouse: guesthouse, active: true
    )

    guest = User.create!(name: 'erika', email: 'erika@email.com', password: 'password', role: :guest, social_security_number: '271.851.455-89')
    
    Reservation.create!(start_date:  1.day.from_now, end_date: 5.days.from_now, guests_number: 5, room: room, user_id: guest.id)

    visit guesthouse_room_path(guesthouse, room)
    fill_in 'Data de Entrada', with: 1.day.from_now
    fill_in 'Data de Saída', with: 5.days.from_now
    fill_in 'Quantidade de Hóspedes', with: 8
    click_on 'Verificar Disponibilidade'

    expect(page).to have_content 'O quarto não está disponível para o período selecionado.'
  end

  it 'and the amount of people is greater then room capacity' do 
    host = User.create!(name: 'Andre', email: 'andre@email.com', password: 'password', role: 8)

    guesthouse = Guesthouse.create!(
      brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
      email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
      postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
      usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user: host
    )

    room = Room.create!(
      name: 'Ruby', description: 'Quarto grande com duas camas de casal e uma de solteiro', 
      dimension: 40, capacity: 5, daily_rate: 200, bathroom: true, balcony: true, air_conditioning: true, 
      television: true, closet: true, safe: true, accessibility: true, guesthouse: guesthouse, active: true
    )
   
    visit guesthouse_room_path(guesthouse, room)
    fill_in 'Data de Entrada', with: 1.day.from_now
    fill_in 'Data de Saída', with: 5.days.from_now
    fill_in 'Quantidade de Hóspedes', with: 8
    click_on 'Verificar Disponibilidade'

    expect(page).to have_content 'O quarto não suporta a quantidade de hóspedes.'
  end

  it 'and de end date must be greater then start date' do 
    host = User.create!(name: 'Andre', email: 'andre@email.com', password: 'password', role: 8)

    guesthouse = Guesthouse.create!(
      brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
      email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
      postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
      usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user: host
    )

    room = Room.create!(
      name: 'Ruby', description: 'Quarto grande com duas camas de casal e uma de solteiro', 
      dimension: 40, capacity: 5, daily_rate: 200, bathroom: true, balcony: true, air_conditioning: true, 
      television: true, closet: true, safe: true, accessibility: true, guesthouse: guesthouse, active: true
    )
   
    visit guesthouse_room_path(guesthouse, room)
    fill_in 'Data de Entrada', with: 1.day.from_now
    fill_in 'Data de Saída', with: Date.today - 5
    fill_in 'Quantidade de Hóspedes', with: 5
    click_on 'Verificar Disponibilidade'

    expect(page).to have_content 'Data de Saída deve ser maior que a data inicial.'
  end

  it 'and de start date must be greater then today' do 
    host = User.create!(name: 'Andre', email: 'andre@email.com', password: 'password', role: 8)

    guesthouse = Guesthouse.create!(
      brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
      email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
      postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
      usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user: host
    )

    room = Room.create!(
      name: 'Ruby', description: 'Quarto grande com duas camas de casal e uma de solteiro', 
      dimension: 40, capacity: 5, daily_rate: 200, bathroom: true, balcony: true, air_conditioning: true, 
      television: true, closet: true, safe: true, accessibility: true, guesthouse: guesthouse, active: true
    )
   
    visit guesthouse_room_path(guesthouse, room)
    fill_in 'Data de Entrada', with: Date.today - 1
    fill_in 'Data de Saída', with: 7.day.from_now
    fill_in 'Quantidade de Hóspedes', with: 5
    click_on 'Verificar Disponibilidade' 

    expect(page).to have_content 'Data de Entrada deve ser maior que a data atual.'
    end
end
