require 'rails_helper'

describe 'User visits home page' do 
  it 'and sees the app name as title linking to home' do 
    # Arrange

    # Act        
    visit ('/')

    # Assert
    within('h1') { expect(page).to have_link('InnSight', href: root_path) }
  end

  context 'when guest' do
    it "and don't sees a link to my_guesthouse" do 
      guest = User.create!(name: 'Andre', email: 'andre@email.com', password: 'password', role: 4, social_security_number: '271.851.455-89')

      login_as guest
      visit root_path

      expect(page).not_to have_content 'Minha Pousada'
    end
  end

  it 'and sees the three most recent active guesthouses' do
    4.times do |n|
      user = User.create!(
        email: "host#{n}@example.com", password: 'password', name: "Host #{n}", role: :host
      )

      Guesthouse.create!(
        brand_name: "Pousada #{n}", corporate_name: "Corporate #{n}", tax_code: "00.000.000/0001-#{n}", 
        phone: "11 99999-000#{n}", email: "pousada#{n}@example.com", address: "Endereço #{n}",
        district: "Bairro #{n}", state: "Estado #{n}", city: "Cidade #{n}", postal_code: "00000-00#{n}",
        description: "Descrição da Pousada #{n}", accepts_pets: true, active: true, usage_policy: "Política de Uso #{n}", 
        check_in: Time.now, check_out: Time.now, user: user
      )
    end

    visit root_path
    
    expect(page).to have_selector('div.recent-guesthouse', count: 3)
    expect(page).to have_content 'Pousada 3'
    expect(page).to have_content 'Pousada 2'
    expect(page).to have_content 'Pousada 1'
  end

  it 'and sees the rest of the active guesthouses, excluding the three most recent ones' do
    5.times do |n|
      user = User.create!(
        email: "host#{n}@example.com", password: 'password', name: "Host #{n}", role: :host
      )

      Guesthouse.create!(
        brand_name: "Pousada #{n}", corporate_name: "Corporate #{n}", tax_code: "00.000.000/0001-#{n}",
        phone: "11 99999-000#{n}", email: "pousada#{n}@example.com", address: "Endereço #{n}",
        district: "Bairro #{n}", state: "Estado #{n}", city: "Cidade #{n}", postal_code: "00000-00#{n}",
        description: "Descrição da Pousada #{n}", accepts_pets: n.even?, active: n.even?, usage_policy: "Política de Uso #{n}", 
        check_in: Time.now, check_out: Time.now, user: user
      )
    end

    visit root_path
    
    expect(page).not_to have_content 'Pousada 1'
    expect(page).not_to have_content 'Pousada 3'
    expect(page).to have_content 'Pousada 2'
    expect(page).to have_content 'Pousada 0'
  end
  
  context 'city menu' do  
    it 'sees a city menu' do
      # Arrange
      ['Cidade A', 'Cidade B', 'Cidade C'].each_with_index do |city, index|
        user = User.create!(email: "#{city.downcase.gsub(' ', '')}@example.com", 
                            password: 'password', name: "Host #{city}", role: :host)
    
        Guesthouse.create!(
          brand_name: "Pousada em #{city}", corporate_name: "Corp #{city}", tax_code: "123456789", 
          phone: "123456789", email: "contact@#{city.downcase.gsub(' ', '')}.com", address: "Rua Principal, 1",
          district: "Centro", state: "Estado", city: city, postal_code: "12345-678", 
          description: "Descrição da Pousada em #{city}", accepts_pets: true, active: index != 2, 
          usage_policy: "Uso permitido", check_in: Time.now, check_out: Time.now, user: user
        )
      end
    
      # Act
      visit root_path
    
      # Assert
      expect(page).to have_selector('div.city-menu')
      expect(page).to have_content('Cidade A')
      expect(page).to have_content('Cidade B')
      expect(page).not_to have_content('Cidade C')
    end
    

    it 'and allows selection' do
      # Arrange
      ['Cidade A', 'Cidade B', 'Cidade C'].each do |city|
        user = User.create!(email: "#{city.downcase.gsub(' ', '')}@example.com", 
                            password: 'password', name: "Host #{city}", role: :host)

        Guesthouse.create!(
          brand_name: "Pousada em #{city}", corporate_name: "Corp #{city}", tax_code: "123456789", 
          phone: "123456789", email: "contact@#{city.downcase.gsub(' ', '')}.com", address: "Rua Principal, 1",
          district: "Centro", state: "Estado", city: city, postal_code: "12345-678", 
          description: "Descrição da Pousada em #{city}", accepts_pets: true, active: true, 
          usage_policy: "Uso permitido", check_in: Time.now, check_out: Time.now, user: user
        )
      end

      # Act
      visit root_path
      click_on 'Cidade A'

      # Assert      
      expect(current_path).to eq city_guesthouses_path('cidade-a')
    end
  end
end