require 'rails_helper'

describe 'Innsight API' do
  context 'GET /api/v1/guesthouses/:guesthouse_id/rooms' do
    it 'returns all active rooms for the guesthouse' do 
      host = User.create(role: :host, name: 'Erika Campos', email: 'erika@email.com', password: 'password')
      guesthouse = Guesthouse.create!(
        brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
        email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
        postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
        usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user: host
      )
      active_room = Room.create!(
        name: 'Diamante', description: 'Quarto grande com duas camas de casal e uma de solteiro', 
        dimension: 40, capacity: 5, daily_rate: 200, bathroom: true, balcony: true, air_conditioning: true, 
        television: true, closet: true, safe: true, accessibility: true, guesthouse: guesthouse, active: true
      )
      inactive_room = Room.create!(
        name: 'Ruby', description: 'Quarto casal', 
        dimension: 20, capacity: 2, daily_rate: 100, bathroom: true, balcony: true, air_conditioning: true, 
        television: true, closet: false, safe: false, accessibility: true, active: false, guesthouse: guesthouse
      )

      get "/api/v1/guesthouses/#{guesthouse.id}/rooms"

      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)

      expect(json_response.count).to eq(1)
      expect(json_response.first['id']).to eq(active_room.id)
      expect(json_response).not_to include(inactive_room.id)
    end

    it 'returns a 404 not found status if guesthouse does not exist' do
      get '/api/v1/guesthouses/nonexistent_id/rooms'

      expect(response).to have_http_status(404)
      expect(response.body).to include('Guesthouse not found')
    end
      
  end
  
  context 'POST /api/v1/rooms/:room_id/availability' do
    it 'returns the total price for the reservation period' do
      host = User.create(role: :host, name: 'Erika Campos', email: 'erika@email.com', password: 'password')
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

      post "/api/v1/rooms/#{room.id}/availability", params: {
        start_date: 1.day.from_now,
        end_date: 3.days.from_now,
        guests_number: 2
      }

      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')

      json_response = JSON.parse(response.body)

      expect(json_response['total_price'].to_f).to eq(600.0)
    end

    it 'returns an error message when not available' do
      host = User.create(role: :host, name: 'Erika Campos', email: 'erika@email.com', password: 'password')
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
      guest = User.create!(
        name: 'André', email: 'andre@email.com', password: 'password', role: :guest, social_security_number: '546.396.043-78'
      )
  
      room.reservations.create!(
        start_date: 1.day.from_now,
        end_date: 3.days.from_now,
        guests_number: 2,
        user: guest
      )

      post "/api/v1/rooms/#{room.id}/availability", params: {
        start_date: 1.day.from_now,
        end_date: 3.days.from_now,
        guests_number: 2
      }

      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq('Room is not available for the selected dates')
    end
  end
  

end
