require 'rails_helper'

describe 'User searchs for guesthouses' do 
  it 'by brand name, city, district and lists results' do 
    user = User.create!(email: 'joao@example.com', password: 'password', name: 'João', role: :host)
    guesthouse_by_name =  Guesthouse.create!(
      brand_name: 'Pousada Feliz', corporate_name: 'Corp Pousada Feliz', tax_code: '123456789',
      phone: '123456789', email: 'contact@pousadafeliz.com', address: 'Rua da Alegria, 1',
      district: 'Bairro Pousada', state: 'Estado', city: 'Cidade Pousada', postal_code: '12345-678',
      description: 'Uma pousada feliz', accepts_pets: true, active: true,
      usage_policy: 'Uso permitido', check_in: Time.now, check_out: Time.now, user: user
    )

    second_user = User.create!(email: 'erika@example.com', password: 'password', name: 'Erika', role: :host)
    guesthouse_by_city =  Guesthouse.create!(
      brand_name: 'Pousada Maravilha', corporate_name: 'Corp Pousada Alegria', tax_code: '123456789',
      phone: '123456789', email: 'contact@pousadamaravilha.com', address: 'Rua da Alegria, 1',
      district: 'Bairro Maravilha', state: 'Estado', city: 'Cidade Feliz', postal_code: '12345-678',
      description: 'Uma pousada maravilhosa', accepts_pets: true, active: true,
      usage_policy: 'Uso permitido', check_in: Time.now, check_out: Time.now, user: second_user
    )

    third_user = User.create!(email: 'andre@example.com', password: 'password', name: 'André', role: :host)
    guesthouse_by_district =  Guesthouse.create!(
      brand_name: 'Pousada Alegria', corporate_name: 'Corp Pousada Alegria', tax_code: '123456789',
      phone: '123456789', email: 'contact@pousadafeliz.com', address: 'Rua da Alegria, 1',
      district: 'Bairro Feliz', state: 'Estado', city: 'Cidade Pousada 3', postal_code: '12345-678',
      description: 'Uma pousada maravilhosa', accepts_pets: true, active: true,
      usage_policy: 'Uso permitido', check_in: Time.now, check_out: Time.now, user: third_user
    )

    # Act
    visit root_path
    fill_in 'Busca', with: 'Feliz'
    click_on 'Buscar'

    # Assert
    expect(page).to have_content 'Termo buscado: Feliz'
    expect(page).to have_content '3 registros encontrados'
    expect(page).to have_link 'Pousada Feliz', href: guesthouse_path(guesthouse_by_name)
    expect(page).to have_link 'Pousada Maravilha', href: guesthouse_path(guesthouse_by_city)
    expect(page).to have_link 'Pousada Alegria', href: guesthouse_path(guesthouse_by_district)
  end

  it 'and finds no result' do 
    # Act
    visit root_path
    fill_in 'Busca', with: 'Feliz'
    click_on 'Buscar'

    # Assert
    expect(page).to have_content 'Termo buscado: Feliz'
    expect(page).to have_content 'Nenhum resultado para o termo'
  end

  it 'and views the result in alphabetic order' do 
    user = User.create!(email: 'joao@example.com', password: 'password', name: 'João', role: :host)
    guesthouse_by_name =  Guesthouse.create!(
      brand_name: 'Pousada Feliz', corporate_name: 'Corp Pousada Feliz', tax_code: '123456789',
      phone: '123456789', email: 'contact@pousadafeliz.com', address: 'Rua da Alegria, 1',
      district: 'Bairro Pousada', state: 'Estado', city: 'Cidade Pousada', postal_code: '12345-678',
      description: 'Uma pousada feliz', accepts_pets: true, active: true,
      usage_policy: 'Uso permitido', check_in: Time.now, check_out: Time.now, user: user
    )

    second_user = User.create!(email: 'erika@example.com', password: 'password', name: 'Erika', role: :host)
    guesthouse_by_city =  Guesthouse.create!(
      brand_name: 'Pousada Maravilha', corporate_name: 'Corp Pousada Alegria', tax_code: '123456789',
      phone: '123456789', email: 'contact@pousadamaravilha.com', address: 'Rua da Alegria, 1',
      district: 'Bairro Maravilha', state: 'Estado', city: 'Cidade Feliz', postal_code: '12345-678',
      description: 'Uma pousada maravilhosa', accepts_pets: true, active: true,
      usage_policy: 'Uso permitido', check_in: Time.now, check_out: Time.now, user: second_user
    )

    third_user = User.create!(email: 'andre@example.com', password: 'password', name: 'André', role: :host)
    guesthouse_by_district =  Guesthouse.create!(
      brand_name: 'Pousada Alegria', corporate_name: 'Corp Pousada Alegria', tax_code: '123456789',
      phone: '123456789', email: 'contact@pousadafeliz.com', address: 'Rua da Alegria, 1',
      district: 'Bairro Feliz', state: 'Estado', city: 'Cidade Pousada 3', postal_code: '12345-678',
      description: 'Uma pousada maravilhosa', accepts_pets: true, active: true,
      usage_policy: 'Uso permitido', check_in: Time.now, check_out: Time.now, user: third_user
    )

    # Act
    visit root_path
    fill_in 'Busca', with: 'Feliz'
    click_on 'Buscar'

    # Assert
    expect(page.body.index('Pousada Alegria')).to be < page.body.index('Pousada Feliz')
    expect(page.body.index('Pousada Feliz')).to be < page.body.index('Pousada Maravilha')
  end

  it 'from the advanced search screen' do
    # Arrange
    user = User.create!(email: 'joao@example.com', password: 'password', name: 'João', role: :host)
    guesthouse = Guesthouse.create!(
      brand_name: 'Pousada Feliz', corporate_name: 'Corp Pousada Feliz', tax_code: '123456789',
      phone: '123456789', email: 'contact@pousadafeliz.com', address: 'Rua da Alegria, 1',
      district: 'Bairro Pousada', state: 'Estado', city: 'Cidade Pousada', postal_code: '12345-678',
      description: 'Uma pousada feliz', accepts_pets: true, active: true,
      usage_policy: 'Uso permitido', check_in: Time.now, check_out: Time.now, user: user
    )
    Room.create!(
      name: 'Diamante', description: 'Quarto grande com duas camas de casal e uma de solteiro',
      dimension: 40, capacity: 5, daily_rate: 200, bathroom: true, balcony: true, air_conditioning: true,
      television: true, closet: true, safe: true, accessibility: true, guesthouse: guesthouse
    )

    second_user = User.create!(email: 'erika@example.com', password: 'password', name: 'Erika', role: :host)
    second_guesthouse = Guesthouse.create!(
      brand_name: 'Pousada Maravilha', corporate_name: 'Corp Pousada Alegria', tax_code: '123456789',
      phone: '123456789', email: 'contact@pousadamaravilha.com', address: 'Rua da Alegria, 1',
      district: 'Bairro Pousada', state: 'Estado', city: 'Cidade Pousada', postal_code: '12345-678',
      description: 'Uma pousada maravilhosa', accepts_pets: true, active: true,
      usage_policy: 'Uso permitido', check_in: Time.now, check_out: Time.now, user: second_user
    )
    Room.create!(
      name: 'Ruby', description: 'Quarto com duas camas de casal',
      dimension: 35, capacity: 4, daily_rate: 150, bathroom: true, balcony: true, air_conditioning: true,
      television: true, closet: true, safe: true, accessibility: true, guesthouse: second_guesthouse
    )

    third_user = User.create!(email: 'andre@example.com', password: 'password', name: 'André', role: :host)
    third_guesthouse = Guesthouse.create!(
      brand_name: 'Pousada Alegria', corporate_name: 'Corp Pousada Alegria', tax_code: '123456789',
      phone: '123456789', email: 'contact@pousadaalegria.com', address: 'Rua da Alegria, 1',
      district: 'Bairro Alegria', state: 'Estado', city: 'Cidade Pousada 3', postal_code: '12345-678',
      description: 'Uma pousada alegre', accepts_pets: false, active: true,
      usage_policy: 'Uso permitido', check_in: Time.now, check_out: Time.now, user: third_user
    )
    Room.create!(
      name: 'Esmeralda', description: 'Quarto pequeno com uma cama de casal',
      dimension: 20, capacity: 2, daily_rate: 100, bathroom: false, balcony: false, air_conditioning: false,
      television: false, closet: false, safe: false, accessibility: false, guesthouse: third_guesthouse
    )

    # Act
    visit root_path
    click_on 'Busca Avançada'
    fill_in 'Cidade', with: 'Cidade Pousada'
    fill_in 'Bairro', with: 'Bairro Pousada'
    fill_in 'Capacidade', with: 4
    check 'Aceita Pets'
    check 'Banheiro'
    check 'Varanda'
    check 'Ar condicionado'
    check 'Televisão'
    check 'Guarda-roupas'
    check 'Cofre'
    check 'Acessibilidade'
    click_on 'Buscar'

    # Assert
    expect(page).to have_content '2 registros encontrados'
    within('div.active_filters') do 
      expect(page).to have_content "Filtros ativos:"
      expect(page).to have_content 'Cidade: Cidade Pousada'
      expect(page).to have_content 'Bairro: Bairro Pousada'
      expect(page).to have_content 'Capacidade: 4 pessoas'
      expect(page).to have_content 'Aceita Pets'
      expect(page).to have_content 'Banheiro'
      expect(page).to have_content 'Varanda'
      expect(page).to have_content 'Ar condicionado'
      expect(page).to have_content 'Televisão'
      expect(page).to have_content 'Guarda-roupas'
      expect(page).to have_content 'Cofre'
      expect(page).to have_content 'Acessibilidade'
    end
    expect(page).to have_link 'Pousada Feliz', href: guesthouse_path(guesthouse)
    expect(page).to have_link 'Pousada Maravilha', href: guesthouse_path(second_guesthouse)
    expect(page).not_to have_link 'Pousada Alegria', href: guesthouse_path(third_guesthouse)
  end

  it 'from the advanced search screen with no filters' do
    visit root_path
    click_on 'Busca Avançada'
    click_on 'Buscar'

    expect(page).to have_content 'Nenhum filtro de busca foi selecionado.'
  end

end