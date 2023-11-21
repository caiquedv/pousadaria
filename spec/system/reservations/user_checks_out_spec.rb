require 'rails_helper'

describe 'User checks out' do
  it "from 'active stays' screen" do 
    host = User.create!(name: 'Andre', email: 'andre@email.com', password: 'password', role: :host)

    PaymentMethod.create!(name: 'Pix')
  
    guesthouse = Guesthouse.create!(
      brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
      email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
      postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
      usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user: host,
      payment_method_ids: [PaymentMethod.last.id]
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
      start_date: (Time.zone.today), end_date: (Time.zone.today + 2.days), guests_number: 5, total_price: 1400, code: 'A2A2B2B2',
      room: room, status: :active, checked_in_at: Time.zone.now
    )

    login_as host
    visit reservations_path(only_active: true)
    click_on Reservation.last.code
    click_on 'Fazer Check-out'
    select 'Pix', from: 'Métodos de Pagamento'
    click_on 'Salvar'

    reservation = Reservation.last
    
    expect(reservation.checked_out_at).to be_within(1.second).of Time.zone.now
    expect(reservation.payment_method.name).to eq 'Pix'
    expect(reservation.total_due).to eq 200
    expect(reservation.status).to eq 'finished'
  end

  it 'before regular check out hour' do
    host = User.create!(name: 'Andre', email: 'andre@email.com', password: 'password', role: :host)

    PaymentMethod.create!(name: 'Pix')
  
    guesthouse = Guesthouse.create!(
      brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
      email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
      postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
      usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user: host,
      payment_method_ids: [PaymentMethod.last.id]
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
      start_date: (Time.zone.today), end_date: (Time.zone.today + 2.days), guests_number: 5, total_price: 1400, code: 'A2A2B2B2',
      room: room, status: 'finished', checked_in_at: Time.zone.now, checked_out_at: 2.days.from_now,
      payment_method_id: PaymentMethod.last.id
    )

    reservation = Reservation.last
    
    expect(reservation.finish_reservation).to eq 600
  end
end
