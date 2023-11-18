require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe '#valid?' do
    it 'start_date, end_date and guests_number are mandatory' do
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

      reservation = Reservation.new(start_date: '', end_date: '', guests_number: '', room: room)

      reservation.valid?

      expect(reservation.errors.include? :start_date).to eq true
      expect(reservation.errors.include? :end_date).to eq true
      expect(reservation.errors.include? :guests_number).to eq true
    end
  end

  describe '#check_availability' do
    it 'adds an error if guests_number exceeds room capacity' do
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

      reservation = Reservation.new(start_date: Date.today, end_date: Date.tomorrow, guests_number: 6, room: room)
      
      reservation.valid?
      
      expect(reservation.errors[:base]).to include('O quarto não suporta a quantidade de hóspedes.')
    end
  end

  let(:host) { User.create!(name: 'Andre', email: 'andre@email.com', password: 'password', role: 8) }

  let (:guesthouse) do 
    Guesthouse.create!(
      brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
      email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
      postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
      usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user: host
    )
  end

  let(:room) do  
      Room.create!(
      name: 'Ruby', description: 'Quarto grande com duas camas de casal e uma de solteiro', 
      dimension: 40, capacity: 5, daily_rate: 200, bathroom: true, balcony: true, air_conditioning: true, 
      television: true, closet: true, safe: true, accessibility: true, guesthouse: guesthouse, active: true
    )
  end

  let(:seasonal_rate) do
    SeasonalRate.create!(
      description: 'Alta temporada',
      start_date: Date.tomorrow,
      end_date: Date.today + 7.days,
      daily_rate: 300,
      room: room
    )
  end

  describe '#calculate_total_price' do
    context 'without seasonal rates' do
      it 'calculates total price based on room daily rate' do
        reservation = Reservation.new(
          start_date: Date.tomorrow + 10.days, 
          end_date: Date.today + 12.days, 
          guests_number: 4, 
          room: room
        )

        reservation.process_reservation
        expected_price = room.daily_rate * 2
        expect(reservation.total_price).to eq(expected_price)
      end
    end

    context 'with seasonal rates' do
      it 'calculates total price based on seasonal rate' do
        reservation = Reservation.new(
          start_date: Date.tomorrow, 
          end_date: Date.today + 3.days, 
          guests_number: 4, 
          room: room
        )

        seasonal_rate
        reservation.process_reservation
        expected_price = seasonal_rate.daily_rate * 3 
        expect(reservation.total_price).to eq(expected_price)
      end
    end

    context 'mix of normal and seasonal rates' do
      it 'calculates total price correctly' do
        reservation = Reservation.new(
          start_date: Date.tomorrow, 
          end_date: Date.today + 10.days, 
          guests_number: 4, 
          room: room
        )

        seasonal_rate
        reservation.process_reservation
        expected_price = seasonal_rate.daily_rate * 7 + room.daily_rate * 3 
        expect(reservation.total_price).to eq(expected_price)
      end
    end
  end

  describe '#check_capacity' do
    it 'adds an error if guests_number exceeds room capacity' do
      reservation = Reservation.new(start_date: Date.today, end_date: Date.tomorrow, guests_number: 6, room: room)
      reservation.valid?
      expect(reservation.errors[:base]).to include('O quarto não suporta a quantidade de hóspedes.')
    end
  end
  
end
