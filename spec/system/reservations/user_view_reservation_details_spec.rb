require 'rails_helper'

describe 'User view reservation details' do
  it "accessing list screen" do
    host = User.create!(name: 'Andre', email: 'andre@email.com', password: 'password', role: :host)

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

		guest = User.create!(
			name: 'Erika', email: 'erika@email.com', password: 'password', role: :guest, social_security_number: '546.396.043-78'
		)

		guest.reservations.create!(
			start_date: (Date.today + 10), end_date: (Date.today + 16), guests_number: 5, total_price: 1400, code: 'A2A2B2B2',
			room: room
		)

		login_as host
		visit reservations_path

		expect(page).to have_content "Reserva: #{Reservation.last.code}" 
		expect(page).to have_content "Quarto: #{room.name}"
		expect(page).to have_content "Data de Entrada: #{(Date.today + 10).strftime('%d-%m-%y')}" 
		expect(page).to have_content "#{Reservation.last.guesthouse.check_in.strftime("%H:%M")}"
		expect(page).to have_content "Data de Saída: #{(Date.today + 16).strftime('%d-%m-%y')}"
		expect(page).to have_content "#{Reservation.last.guesthouse.check_out.strftime("%H:%M")}"
		expect(page).to have_content 'Hóspedes: 5 Pessoas'
		expect(page).to have_content "Total: R$ 1400.0"
  end

  context 'when user is authenticated guest' do    
    it 'and can cancel within 7 days' do
      host = User.create!(name: 'Andre', email: 'andre@email.com', password: 'password', role: :host)
  
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
  
      guest = User.create!(
        name: 'Erika', email: 'erika@email.com', password: 'password', role: :guest, social_security_number: '546.396.043-78'
      )
  
      guest.reservations.create!(
        start_date: (Date.today + 10), end_date: (Date.today + 16), guests_number: 5, total_price: 1400, code: 'A2A2B2B2',
        room: room
      )
      
      login_as(guest)
      visit root_path
      click_on 'Minhas Reservas'
      click_on Reservation.last.code
      click_on 'Cancelar'
  
      expect(page).to have_content 'Reserva cancelada com sucesso.'
      within('h2') { expect(page).to have_content 'Reservas' }
      expect(page).not_to have_content "Reserva: #{Reservation.last.code}" 
      expect(Reservation.last.status).to eq 'cancelled'
    end

  end

  context 'when is authenticated host' do
    it "and sees 'reservation' link" do 
      host = User.create!(name: 'Erika', email: 'erika@email.com', password: 'password', role: :host)
      guesthouse = Guesthouse.create!(
        brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
        email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
        postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
        usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user: host
      )
  
      login_as host
      visit root_path
  
      within('nav') { expect(page).to have_link 'Reservas', href: reservations_path }
    end

    it 'and can checks in if the date is greater than the deadline' do
      host = User.create!(name: 'Andre', email: 'andre@email.com', password: 'password', role: :host)
  
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
  
      guest = User.create!(
        name: 'Erika', email: 'erika@email.com', password: 'password', role: :guest, social_security_number: '546.396.043-78'
      )
  
      guest.reservations.create!(
        start_date: (Date.today), end_date: (Date.today + 1), guests_number: 5, total_price: 1400, code: 'A2A2B2B2',
        room: room
      )
      
      login_as(host)
      visit root_path
      click_on 'Reservas'
      click_on Reservation.last.code
      click_on 'Fazer Check-in'
  
      expect(page).to have_content 'Check-in realizado com sucesso.'
      within('h2') { expect(page).to have_content 'Reservas' }
      expect(page).not_to have_content "Reserva: #{Reservation.last.code}" 
      expect(Reservation.last.status).to eq 'active'
      expect(Reservation.last.checked_in_at).to be_within(1.second).of Time.zone.now
    end

    it "on 'active stays' link in the menu" do
      host = User.create!(name: 'Andre', email: 'andre@email.com', password: 'password', role: :host)
  
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
  
      guest = User.create!(
        name: 'Erika', email: 'erika@email.com', password: 'password', role: :guest, social_security_number: '546.396.043-78'
      )
  
      guest.reservations.create!(
        start_date: (Date.today), end_date: (Date.today + 1), guests_number: 5, total_price: 1400, code: 'A2A2B2B2',
        room: room, status: 'active', checked_in_at: Time.zone.now
      )
      
      login_as(host)
      visit root_path
      click_on 'Estadias Ativas'
  
      within('h2') { expect(page).to have_content 'Estadias Ativas' }
      expect(page).to have_content "Reserva: #{Reservation.last.code}" 
      expect(page).to have_content "Check-in realizado em: #{Reservation.last.checked_in_at.strftime("%d-%m-%y %H:%M")}" 
    end

    it 'and can cancel it if the date is 2 days greater than the deadline' do
      host = User.create!(name: 'Andre', email: 'andre@email.com', password: 'password', role: :host)
  
      guesthouse = Guesthouse.create!(
        brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
        email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
        postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
        usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user: host
      )
      
      room = Room.create!(
        name: 'Ruby', description: 'Quarto grande com duas cama s de casal e uma de solteiro', 
        dimension: 40, capacity: 5, daily_rate: 200, bathroom: true, balcony: true, air_conditioning: true, 
        television: true, closet: true, safe: true, accessibility: true, guesthouse: guesthouse, active: true
      )
  
      guest = User.create!(
        name: 'Erika', email: 'erika@email.com', password: 'password', role: :guest, social_security_number: '546.396.043-78'
      )
  
      guest.reservations.create!(
        start_date: (Date.today + 1), end_date: (Date.today + 7), guests_number: 5, total_price: 1400, code: 'A2A2B2B2',
        room: room
      )
      Reservation.last.update(start_date: 2.days.ago.to_date)
      
      login_as(host)
      visit root_path
      click_on 'Reservas'
      click_on Reservation.last.code
      click_on 'Cancelar'

      expect(page).to have_content 'Reserva cancelada com sucesso.'
      within('h2') { expect(page).to have_content 'Reservas' }

      expect(Reservation.last.status).to eq 'cancelled'
      expect(page).not_to have_content "Reserva: #{Reservation.last.code}" 
    end

  end
  

end
