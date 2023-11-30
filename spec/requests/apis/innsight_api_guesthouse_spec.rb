require 'rails_helper'

describe 'Innsight API' do
  context 'GET /api/v1/guesthouses' do
    it 'success' do 
      first_host = User.create(role: :host, name: 'Erika Campos', email: 'erika@email.com', password: 'password')
      active_guesthouse = Guesthouse.create!(
        brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
        email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
        postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
        usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user: first_host
      )
      second_host = User.create!(role: :host, name: 'Claudia Capelini', email: 'claudia@email.com', password: 'password')
      inactive_guesthouse = Guesthouse.create!(
        brand_name: 'Preciosa', corporate_name: 'Preciosa Corp', tax_code: '34.683.378/0001-59', phone: '99 99999-9999',
        email: 'preciosa@email.com', address: 'Av. Brilhantina, 1500', district: 'Bairro Preciosa II', state: 'PA', 
        city: 'Paraupebas', postal_code: '90900-000', description: 'Rede hoteleira', accepts_pets: true, 
        usage_policy: 'Política de Uso', check_in: '14:00', check_out: '12:00', user: second_host, active: false
      )

      get '/api/v1/guesthouses'

      expect(response).to have_http_status(200)
      expect(response.content_type).to include 'application/json'
      
      json_response = JSON.parse(response.body)      

      expect(json_response.length).to eq 1
      expect(json_response.first['id']).to eq active_guesthouse.id
    end 

    it 'filters guesthouses by name' do
      first_host = User.create(role: :host, name: 'Erika Campos', email: 'erika@email.com', password: 'password')
      active_guesthouse = Guesthouse.create!(
        brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
        email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
        postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
        usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user: first_host
      )

      get '/api/v1/guesthouses', params: { query: 'mato' }

      json_response = JSON.parse(response.body)      

      expect(response).to have_http_status(200)
      expect(json_response).not_to be_empty
      expect(json_response.first['brand_name']).to eq(active_guesthouse.brand_name)
    end
    
    it 'return empty if no guesthouse' do 
      get '/api/v1/guesthouses'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      
      json_response = JSON.parse(response.body)      

      expect(json_response).to eq []
    end

    it 'returns the guesthouse details with average rating' do
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
      room.reservations.create!(
        start_date: 5.days.from_now, end_date: 8.days.from_now, guests_number: 2, status: 'finished', total_price: 300,
        user: guest, code: 'R2D2R2D2'
      )
      reservation = Reservation.last
      reservation.reviews.create!(rate: 4, message: "Ótimo quarto")

      get "/api/v1/guesthouses/#{guesthouse.id}"

      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')

      json_response = JSON.parse(response.body)

      expect(json_response['id']).to eq(guesthouse.id)
      expect(json_response['average_rating']).to eq 5
      expect(json_response['tax_code']).to be_nil
      expect(json_response['corporate_name']).to be_nil
    end

    it 'returns a 404 not found status if guesthouse does not exist' do
      get '/api/v1/guesthouses/nonexistent_id'
      
      expect(response).to have_http_status(404)
      expect(response.body).to include('Guesthouse not found')
    end

  end

end
