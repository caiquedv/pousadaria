require 'rails_helper'

describe 'User books a room' do
  context 'when is not authenticaded guest' do
    it 'and must LOG IN to view the reservation summary' do 
      host = User.create!(name: 'Andre', email: 'andre@email.com', password: 'password', role: :host)
    
      PaymentMethod.create!(name: 'Dinheiro')
      PaymentMethod.create!(name: 'Débito')
      PaymentMethod.create!(name: 'Pix')
    
      guesthouse = Guesthouse.create!(
        brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
        email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
        postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
        usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user: host, 
        payment_method_ids: PaymentMethod.all.pluck(:id)
      )
      
      room = Room.create!(
        name: 'Ruby', description: 'Quarto grande com duas camas de casal e uma de solteiro', 
        dimension: 40, capacity: 5, daily_rate: 200, bathroom: true, balcony: true, air_conditioning: true, 
        television: true, closet: true, safe: true, accessibility: true, guesthouse: guesthouse, active: true
      )

      guest = User.create!(
        name: 'Erika', email: 'erika@email.com', password: 'password', role: :guest, social_security_number: '546.396.043-78'
      )
     
      visit guesthouse_room_path(guesthouse, room)
      fill_in 'Data de Entrada', with: Date.today + 1
      fill_in 'Data de Saída', with: Date.today + 7
      fill_in 'Quantidade de Hóspedes', with: 5
      click_on 'Verificar Disponibilidade'
      click_on 'Informações da Reserva'
      fill_in 'E-mail', with: 'erika@email.com'
      fill_in 'Senha', with: 'password'
      click_on 'Login'

      within('h2') { expect(page).to have_content 'Resumo da reserva' }
      expect(page).to have_content "Quarto #{room.name}"
      expect(page).to have_content "Data de Entrada: #{(Date.today + 1).strftime("%d-%m-%y")}"
      expect(page).to have_content "Check-in: #{guesthouse.check_in.strftime("%H:%M")}"
      expect(page).to have_content "Data de Saída: #{(Date.today + 7).strftime("%d-%m-%y")}"
      expect(page).to have_content "Check-out: #{guesthouse.check_out.strftime("%H:%M")}"
      expect(page).to have_content "Valor total: R$ 1400.0"
      expect(page).to have_content 'Métodos de pagamento: Dinheiro Débito Pix'
      expect(page).to have_button 'Confirmar Reserva'
    end
    
    it 'and must SIGN UP to view the reservation summary' do 
      host = User.create!(name: 'Andre', email: 'andre@email.com', password: 'password', role: :host)
    
      PaymentMethod.create!(name: 'Dinheiro')
      PaymentMethod.create!(name: 'Débito')
      PaymentMethod.create!(name: 'Pix')
    
      guesthouse = Guesthouse.create!(
        brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
        email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
        postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
        usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user: host, 
        payment_method_ids: PaymentMethod.all.pluck(:id)
      )
      
      room = Room.create!(
        name: 'Ruby', description: 'Quarto grande com duas camas de casal e uma de solteiro', 
        dimension: 40, capacity: 5, daily_rate: 200, bathroom: true, balcony: true, air_conditioning: true, 
        television: true, closet: true, safe: true, accessibility: true, guesthouse: guesthouse, active: true
      )
     
      visit guesthouse_room_path(guesthouse, room)
      fill_in 'Data de Entrada', with: Date.today + 1
      fill_in 'Data de Saída', with: Date.today + 7
      fill_in 'Quantidade de Hóspedes', with: 5
      click_on 'Verificar Disponibilidade'
      click_on 'Informações da Reserva'
      click_on 'Criar conta'
      select 'Hóspede', from: 'Tipo de conta'
      fill_in 'Nome', with: 'Erika'
      fill_in 'CPF', with: '546.396.043-78'
      fill_in 'E-mail', with: 'erika@email.com'
      fill_in 'Senha', with: 'password'
      fill_in 'Confirme sua senha', with: 'password'
      click_on 'Criar conta'
      
      within('h2') { expect(page).to have_content 'Resumo da reserva' }
      expect(page).to have_content "Quarto #{room.name}"
      expect(page).to have_content "Data de Entrada: #{(Date.today + 1).strftime("%d-%m-%y")}"
      expect(page).to have_content "Check-in: #{guesthouse.check_in.strftime("%H:%M")}"
      expect(page).to have_content "Data de Saída: #{(Date.today + 7).strftime("%d-%m-%y")}"
      expect(page).to have_content "Check-out: #{guesthouse.check_out.strftime("%H:%M")}"
      expect(page).to have_content "Valor total: R$ 1400.0"
      expect(page).to have_content 'Métodos de pagamento: Dinheiro Débito Pix'
      expect(page).to have_button 'Confirmar Reserva'
    end

    it "don't sees my reservations link" do
      visit root_path
      
      within('nav') { expect(page).not_to have_link 'Minhas Reservas', href: reservations_path }
    end
    
  end

  context 'when is authenticaded guest' do
    it 'sees my reservations link' do 
      guest = User.create!(name: 'Erika', email: 'erika@email.com', password: 'password', role: :guest, social_security_number: '546.396.043-78')
  
      login_as guest
      visit root_path
  
      within('nav') { expect(page).to have_link 'Minhas Reservas', href: reservations_path }
    end

    it "successfully" do
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
      
      login_as guest
      visit guesthouse_room_path(guesthouse, room)
      fill_in 'Data de Entrada', with: Date.today + 1
      fill_in 'Data de Saída', with: Date.today + 7
      fill_in 'Quantidade de Hóspedes', with: 5
      click_on 'Verificar Disponibilidade'
      click_on 'Informações da Reserva'
      click_on 'Confirmar Reserva'
      
      expect(page).to have_content room.name 
      expect(page).to have_link Reservation.last.code , href: reservation_path(Reservation.last)
    end

    it 'Unsuccessfully' do 
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
      other_guest = User.create!(
        name: 'João', email: 'joao@email.com', password: 'password', role: :guest, social_security_number: '847.506.399-31'
      )
      
      login_as guest
      visit guesthouse_room_path(guesthouse, room)
      fill_in 'Data de Entrada', with: Date.today + 1
      fill_in 'Data de Saída', with: Date.today + 7
      fill_in 'Quantidade de Hóspedes', with: 5
      click_on 'Verificar Disponibilidade'
      click_on 'Informações da Reserva'

      other_guest.reservations.create!(
        start_date: (Date.today + 1), end_date: (Date.today + 7), guests_number: 5, total_price: 1400, code: 'A2A2B2B2', room: room
      )

      click_on 'Confirmar Reserva'

      expect(page).to have_content 'Verifique novamente as informações da reserva e disponibilidade.'
    end  
  end
  

end
