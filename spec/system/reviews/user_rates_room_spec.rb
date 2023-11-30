require 'rails_helper'

describe 'User rates a room after check-out' do
  it 'from finished reservation details screen' do
    first_host = User.create!(role: :host, name: 'Erika Campos', email: 'erika@email.com', password: 'password')
    first_guesthouse = Guesthouse.create!(
      brand_name: 'Preciosa', corporate_name: 'Preciosa Corp', tax_code: '34.683.378/0001-59', phone: '99 99999-9999',
      email: 'preciosa@email.com', address: 'Av. Brilhantina, 1500', district: 'Bairro Preciosa II', state: 'PA', 
      city: 'Paraupebas', postal_code: '90900-000', description: 'Rede hoteleira', accepts_pets: true, 
      usage_policy: 'Política de Uso', check_in: '14:00', check_out: '12:00', user: first_host, active: true
    )
    room = Room.create!(
      name: 'Ruby', description: 'Quarto casal', 
      dimension: 20, capacity: 2, daily_rate: 100, bathroom: true, balcony: true, 
      air_conditioning: true, television: true, closet: false, safe: false, accessibility: true,
      active: true, guesthouse: first_guesthouse
    )
    guest = User.create!(
      name: 'Andre', email: 'andre@email.com', password: 'password', role: 4, social_security_number: '271.851.455-89'
    )
    room.reservations.create!(
      start_date: Time.zone.now, end_date: 3.days.from_now, guests_number: 2, status: 'finished', total_price: 300,
      user: guest, code: 'AWAWS1S1'
    )

    login_as guest
    visit reservation_path(Reservation.last)
    click_on 'Avaliar'
    fill_in 'Nota', with: 5
    fill_in 'Mensagem', with: 'Ótimo quarto'
    click_on 'Enviar'

    expect(page).to have_content 'Avaliação criada com sucesso.'
  end

  it "and can respond through the 'reviews' menu" do 
    host = User.create!(role: :host, name: 'Erika Campos', email: 'erika@email.com', password: 'password')
    guesthouse = Guesthouse.create!(
      brand_name: 'Preciosa', corporate_name: 'Preciosa Corp', tax_code: '34.683.378/0001-59', phone: '99 99999-9999',
      email: 'preciosa@email.com', address: 'Av. Brilhantina, 1500', district: 'Bairro Preciosa II', state: 'PA', 
      city: 'Paraupebas', postal_code: '90900-000', description: 'Rede hoteleira', accepts_pets: true, 
      usage_policy: 'Política de Uso', check_in: '14:00', check_out: '12:00', user: host, active: true
    )
    room = Room.create!(
      name: 'Ruby', description: 'Quarto casal', 
      dimension: 20, capacity: 2, daily_rate: 100, bathroom: true, balcony: true, 
      air_conditioning: true, television: true, closet: false, safe: false, accessibility: true,
      active: true, guesthouse: guesthouse
    )
    guest = User.create!(
      name: 'Andre', email: 'andre@email.com', password: 'password', role: 4, social_security_number: '271.851.455-89'
    )
    room.reservations.create!(
      start_date: Time.zone.now, end_date: 3.days.from_now, guests_number: 2, status: 'finished', total_price: 300,
      user: guest, code: 'AWAWS1S1'
    )
    reservation = Reservation.last
    reservation.reviews.create!(rate: 5, message: "Ótimo quarto")

    login_as host
    visit root_path
    click_on 'Avaliações'
    click_on 'Responder'
    fill_in 'Mensagem', with: 'Obrigado'
    click_on 'Enviar'
    
    expect(page).to have_content 'Resposta enviada com sucesso.'
    expect(page).to have_content "Reserva: #{reservation.code}"
    expect(page).to have_content 'Pousada: Preciosa'
    expect(page).to have_content 'Quarto: Ruby'
    expect(page).to have_content 'Nota: 5'
    expect(page).to have_content 'Mensagens: Ótimo quarto Obrigado'
  end

  it 'and now is possible to see guesthouse rating in the guesthouse details' do
    host = User.create!(role: :host, name: 'Erika Campos', email: 'erika@email.com', password: 'password')
    guesthouse = Guesthouse.create!(
      brand_name: 'Preciosa', corporate_name: 'Preciosa Corp', tax_code: '34.683.378/0001-59', phone: '99 99999-9999',
      email: 'preciosa@email.com', address: 'Av. Brilhantina, 1500', district: 'Bairro Preciosa II', state: 'PA', 
      city: 'Paraupebas', postal_code: '90900-000', description: 'Rede hoteleira', accepts_pets: true, 
      usage_policy: 'Política de Uso', check_in: '14:00', check_out: '12:00', user: host, active: true
    )
    room = Room.create!(
      name: 'Ruby', description: 'Quarto casal', 
      dimension: 20, capacity: 2, daily_rate: 100, bathroom: true, balcony: true, 
      air_conditioning: true, television: true, closet: false, safe: false, accessibility: true,
      active: true, guesthouse: guesthouse
    )
    guest = User.create!(
      name: 'Andre', email: 'andre@email.com', password: 'password', role: 4, social_security_number: '271.851.455-89'
    )
    room.reservations.create!(
      start_date: Time.zone.now, end_date: 3.days.from_now, guests_number: 2, status: 'finished', total_price: 300,
      user: guest, code: 'AWAWS1S1'
    )
    reservation = Reservation.last
    reservation.reviews.create!(rate: 5, message: "Gostei")
    reservation.reviews.create!(rate: 5, message: "Ótimo quarto")
    reservation.reviews.create!(rate: 3, message: "Quarto mediano")
    reservation.reviews.create!(rate: 4, message: "Bom quarto")

    visit guesthouse_path(guesthouse)

    expect(page).to have_content 'Nota média: 4'
    expect(page).to have_content 'Últimas avaliações'
    expect(page).to have_content 'Nota: 5'
    expect(page).to have_content 'Mensagem: Ótimo quarto'
    expect(page).to have_content 'Nota: 3'
    expect(page).to have_content 'Mensagem: Quarto mediano'
    expect(page).to have_content 'Nota: 4'
    expect(page).to have_content 'Mensagem: Bom quarto'    
    expect(page).not_to have_content 'Mensagem: Gostei'
  end

  it 'and can see all guesthouse reviews' do 
    host = User.create!(role: :host, name: 'Erika Campos', email: 'erika@email.com', password: 'password')
    guesthouse = Guesthouse.create!(
      brand_name: 'Preciosa', corporate_name: 'Preciosa Corp', tax_code: '34.683.378/0001-59', phone: '99 99999-9999',
      email: 'preciosa@email.com', address: 'Av. Brilhantina, 1500', district: 'Bairro Preciosa II', state: 'PA', 
      city: 'Paraupebas', postal_code: '90900-000', description: 'Rede hoteleira', accepts_pets: true, 
      usage_policy: 'Política de Uso', check_in: '14:00', check_out: '12:00', user: host, active: true
    )
    room = Room.create!(
      name: 'Ruby', description: 'Quarto casal', 
      dimension: 20, capacity: 2, daily_rate: 100, bathroom: true, balcony: true, 
      air_conditioning: true, television: true, closet: false, safe: false, accessibility: true,
      active: true, guesthouse: guesthouse
    )
    guest = User.create!(
      name: 'Andre', email: 'andre@email.com', password: 'password', role: 4, social_security_number: '271.851.455-89'
    )
    room.reservations.create!(
      start_date: Time.zone.now, end_date: 3.days.from_now, guests_number: 2, status: 'finished', total_price: 300,
      user: guest, code: 'AWAWS1S1'
    )
    reservation = Reservation.last
    reservation.reviews.create!(rate: 5, message: "Gostei")
    reservation.reviews.create!(rate: 5, message: "Ótimo quarto")
    reservation.reviews.create!(rate: 3, message: "Quarto mediano")
    reservation.reviews.create!(rate: 4, message: "Bom quarto")

    visit guesthouse_path(guesthouse)
    click_on 'Ver todas'

    expect(page).to have_content 'Nota: 5'
    expect(page).to have_content 'Mensagens: Gostei'

    expect(page).to have_content 'Nota: 5'
    expect(page).to have_content 'Mensagens: Ótimo quarto'

    expect(page).to have_content 'Nota: 3'
    expect(page).to have_content 'Mensagens: Quarto mediano'

    expect(page).to have_content 'Nota: 4'
    expect(page).to have_content 'Mensagens: Bom quarto'
  end
end
