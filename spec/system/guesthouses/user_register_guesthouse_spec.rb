require 'rails_helper'

describe 'User register a guesthouse' do
  it 'successfully' do
    # Arrange
    user = User.create!(name: 'João', email: 'joao@email.com', password: 'password', role: 8)
    PaymentMethod.create!(name: 'Dinheiro')
    PaymentMethod.create!(name: 'Pix')

    # Act
    login_as(user)
    visit new_guesthouse_path
    fill_in 'Nome Fantasia', with: 'Cantinho no mato'
    fill_in 'Razão Social', with: 'Pousada XYZ'
    fill_in 'CNPJ', with: '25.443.218/0001-41'
    fill_in 'Telefone', with: '11 9999'
    fill_in 'E-mail', with: 'xyz@pousada.com'
    fill_in 'Endereço', with: 'Rua do xyz, 10'
    fill_in 'Bairro', with: 'Bairro do xyz'
    fill_in 'Estado', with: 'MT'
    fill_in 'Cidade', with: 'Campo Verde'
    fill_in 'CEP', with: '78840-000'
    fill_in 'Descrição', with: 'Uma pousada no meio do mato'
    check "payment_method_1"
    check "payment_method_2"
    select 'Sim', from: 'Aceita Pets'
    select 'Sim', from: 'Aceita Reservas'
    fill_in 'Política de Uso', with: 'Uma política de uso bem legal'
    fill_in 'Check In', with: '14:00'
    fill_in 'Check Out', with: '12:00'
    click_on 'Salvar'

    # Assert        
    expect(current_path).to eq root_path
    expect(page).to have_content('Pousada cadastrada com sucesso!')
    guesthouse = Guesthouse.last
    expect(guesthouse.brand_name).to eq 'Cantinho no mato'
    expect(guesthouse.corporate_name).to eq 'Pousada XYZ'
    expect(guesthouse.tax_code).to eq '25.443.218/0001-41'
    expect(guesthouse.phone).to eq '11 9999'
    expect(guesthouse.email).to eq 'xyz@pousada.com'
    expect(guesthouse.address).to eq 'Rua do xyz, 10'
    expect(guesthouse.district).to eq 'Bairro do xyz'
    expect(guesthouse.state).to eq 'MT'
    expect(guesthouse.city).to eq 'Campo Verde'
    expect(guesthouse.postal_code).to eq '78840-000'
    expect(guesthouse.description).to eq 'Uma pousada no meio do mato'
    expect(guesthouse.payment_methods.pluck(:name)).to include 'Dinheiro', 'Pix'
    expect(guesthouse.accepts_pets).to be true
    expect(guesthouse.active).to be true
    expect(guesthouse.usage_policy).to eq 'Uma política de uso bem legal'
    expect(guesthouse.formatted_check_in).to eq '14:00'
    expect(guesthouse.formatted_check_out).to eq '12:00'
  end

  it 'and already has a guesthouse registered' do 
    # Arrange
    user = User.create!(name: 'João', email: 'joao@email.com', password: 'password', role: 8)

    guesthouse = Guesthouse.create!(
      brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
      email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
      postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
      usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user: user
    )
    
    # Act
    login_as(user)
    visit new_guesthouse_path
    
    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você já possui uma pousada cadastrada.'
  end

  it 'only if user is host' do 
    # Arrange
    user = User.create!(name: 'João', email: 'joao@email.com', password: 'password', role: 4, social_security_number: '271.851.455-89')
    
    # Act
    login_as(user)
    visit new_guesthouse_path
    
    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para realizar essa ação.'
  end

  it 'with icomplete data' do 
    # Arrange
    user = User.create!(name: 'João', email: 'joao@email.com', password: 'password', role: 8)
    PaymentMethod.create!(name: 'Dinheiro')
    PaymentMethod.create!(name: 'Pix')

    # Act
    login_as(user)
    visit new_guesthouse_path
    fill_in 'Nome Fantasia', with: 'Cantinho no mato'
    fill_in 'Razão Social', with: ''
    fill_in 'CNPJ', with: ''
    fill_in 'Telefone', with: ''
    fill_in 'E-mail', with: ''
    fill_in 'Endereço', with: ''
    fill_in 'Bairro', with: ''
    fill_in 'Estado', with: ''
    fill_in 'Cidade', with: ''
    fill_in 'CEP', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Check In', with: ''
    fill_in 'Check Out', with: ''
    click_on 'Salvar'

    # Assert        
    
    expect(page).to have_content 'Pousada não cadastrada!'
    expect(page).to have_content 'Razão Social não pode ficar em branco'
    expect(page).to have_content 'CNPJ não pode ficar em branco'
    expect(page).to have_content 'Telefone não pode ficar em branco'
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'Endereço não pode ficar em branco'
    expect(page).to have_content 'Bairro não pode ficar em branco'
    expect(page).to have_content 'Estado não pode ficar em branco'
    expect(page).to have_content 'Cidade não pode ficar em branco'
    expect(page).to have_content 'CEP não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Check In não pode ficar em branco'
    expect(page).to have_content 'Check Out não pode ficar em branco'    

    
  end

  it 'and persists data when fail' do
    # Arrange
    user = User.create!(name: 'João', email: 'joao@email.com', password: 'password', role: 8)
    PaymentMethod.create!(name: 'Dinheiro')
    PaymentMethod.create!(name: 'Pix')

    # Act
    login_as(user)
    visit new_guesthouse_path
    fill_in 'Nome Fantasia', with: 'Cantinho no mato'
    fill_in 'Razão Social', with: 'Pousada XYZ'
    fill_in 'CNPJ', with: '25.443.218/0001-41'
    click_on 'Salvar'

    # Assert        
    expect(page).to have_field 'Nome Fantasia', with: 'Cantinho no mato'
    expect(page).to have_field 'Razão Social', with: 'Pousada XYZ'
    expect(page).to have_field 'CNPJ', with: '25.443.218/0001-41'
  end

  it 'and do logout without register a guesthouse' do
    # Arrange
    host = User.create!(name: 'João', email: 'joao@email.com', password: 'password', role: 'host')
    
    # Act
    login_as host
    visit root_path
    click_on 'Sair'
  
    # Assert
    expect(page).to have_content 'Logout efetuado com sucesso.'
    expect(page).to have_link 'Entrar'
    expect(page).not_to have_button 'Sair'
    expect(page).not_to have_content 'joao@email.com'
  end
end
