first_host = User.create!(role: :host, name: 'Erika Campos', email: 'erika@email.com', password: 'password')
second_host = User.create!(role: :host, name: 'Claudia Capelini', email: 'claudia@email.com', password: 'password')
third_host = User.create!(role: :host, name: 'André Kanamura', email: 'andre@email.com', password: 'password')

PaymentMethod.create!(name: 'Pix')
PaymentMethod.create!(name: 'Dinheiro')
PaymentMethod.create!(name: 'Débito')

first_guesthouse = Guesthouse.create!(
  brand_name: 'Preciosa', corporate_name: 'Preciosa Corp', tax_code: '34.683.378/0001-59', phone: '99 99999-9999',
  email: 'preciosa@email.com', address: 'Av. Brilhantina, 1500', district: 'Bairro Preciosa II', state: 'PA', 
  city: 'Paraupebas', postal_code: '90900-000', description: 'Rede hoteleira', accepts_pets: true, 
  usage_policy: 'Política de Uso', check_in: '14:00', check_out: '12:00', active: true, 
  payment_method_ids: PaymentMethod.all.pluck(:id), user: first_host
)

second_guesthouse = Guesthouse.create!(
  brand_name: 'Céu Azul', corporate_name: 'Céu Azul Corp', tax_code: '85.336.615/0001-46', phone: '65 98888-8888',
  email: 'ceuazul@email.com', address: 'Av. Rio Claro, 300', district: 'Bairro Azul', state: 'MT',
  city: 'Jaciara', postal_code: '78800-000', description: 'Pousadas em Mato Grosso', accepts_pets: true, 
  usage_policy: 'Política de Uso', check_in: '13:00', check_out: '11:00', active: true, 
  payment_method_ids: [1, 2], user: second_host
)

third_guesthouse = Guesthouse.create!(
  brand_name: 'Arco-Íris', corporate_name: 'Íris Ltda', tax_code: '35.541.346/0001-81', phone: '11 97777-7777',
  email: 'arcoiris@email.com', address: 'Av. Paulista, 820', district: 'Bairro das Cores', state: 'SP',
  city: 'São Paulo', postal_code: '03736-200', description: 'Hotéis urbanos', accepts_pets: false, 
  usage_policy: 'Política de Uso', check_in: '17:00', check_out: '15:00', active: false, 
  payment_method_ids: [2, 3], user: third_host
)

first_guesthouse_room_one = Room.create!(
  name: 'Diamante', description: 'Quarto grande com duas camas de casal e uma de solteiro', 
  dimension: 50, capacity: 5, daily_rate: 200, bathroom: true, balcony: true, 
  air_conditioning: true, television: true, closet: true, safe: true, accessibility: true,
  active: true, guesthouse: first_guesthouse
)

first_guesthouse_room_two = Room.create!(
  name: 'Ruby', description: 'Quarto casal', 
  dimension: 20, capacity: 2, daily_rate: 100, bathroom: true, balcony: true, 
  air_conditioning: true, television: true, closet: false, safe: false, accessibility: true,
  active: true, guesthouse: first_guesthouse
)

first_guesthouse_inactive_room = Room.create!(
  name: 'Pérola', description: 'Quarto', 
  dimension: 30, capacity: 2, daily_rate: 80, bathroom: true, balcony: true, 
  air_conditioning: true, television: false, closet: false, safe: false, accessibility: true,
  active: false, guesthouse: first_guesthouse
)

second_guesthouse_room_one = Room.create!(
  name: 'Gaivota', description: 'Quarto família', 
  dimension: 60, capacity: 6, daily_rate: 250, bathroom: true, balcony: true, 
  air_conditioning: true, television: true, closet: true, safe: true, accessibility: true,
  active: true, guesthouse: second_guesthouse
)

second_guesthouse_room_two = Room.create!(
  name: 'Sabiá', description: 'Quarto casal + solteiro', 
  dimension: 30, capacity: 3, daily_rate: 100, bathroom: true, balcony: false, 
  air_conditioning: true, television: false, closet: true, safe: false, accessibility: true,
  active: true, guesthouse: second_guesthouse
)

second_guesthouse_inactive_room = Room.create!(
  name: 'Arara', description: 'Quarto', 
  dimension: 30, capacity: 2, daily_rate: 80, bathroom: true, balcony: true, 
  air_conditioning: true, television: false, closet: false, safe: false, accessibility: true,
  active: false, guesthouse: second_guesthouse
)

third_guesthouse_room_one = Room.create!(
  name: 'Azul', description: 'Quarto casal grande', 
  dimension: 30, capacity: 2, daily_rate: 150, bathroom: true, balcony: true, 
  air_conditioning: true, television: false, closet: true, safe: true, accessibility: true,
  active: true, guesthouse: third_guesthouse
)

third_guesthouse_room_two = Room.create!(
  name: 'Verde', description: 'Quarto família grande', 
  dimension: 50, capacity: 4, daily_rate: 200, bathroom: true, balcony: true, 
  air_conditioning: true, television: true, closet: true, safe: true, accessibility: true,
  active: true, guesthouse: third_guesthouse
)

third_guesthouse_inactive_room = Room.create!(
  name: 'Amarelo', description: 'Quarto', 
  dimension: 30, capacity: 2, daily_rate: 80, bathroom: true, balcony: true, 
  air_conditioning: true, television: false, closet: false, safe: false, accessibility: true,
  active: false, guesthouse: first_guesthouse
)

Room.all.each do |room| 
  room.seasonal_rates.create!(
    description: 'Feriado', start_date: 2.days.from_now, end_date: 6.days.from_now,
    daily_rate: 450
  )


end