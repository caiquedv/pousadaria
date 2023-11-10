require 'rails_helper'

describe 'User register a room for your guesthouse' do
  it 'Successfully from my_gusthouse screen' do 
    # Arrange
    user = User.create!(name: 'João', email: 'joao@email.com', password: 'password', role: 8)
    
    guesthouse = Guesthouse.create!(
      brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
      email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
      postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
      usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user: user
    )

    # Act
    login_as user
    visit root_path
    click_on 'Minha Pousada'
    click_on 'Cadastrar quarto'
    fill_in 'Nome', with: 'Diamante'
    fill_in 'Descrição', with: 'Quarto grande com duas camas de casal e uma de solteiro'
    fill_in 'Dimensão', with: 20
    fill_in 'Capacidade', with: 5
    fill_in 'Valor da diária', with: 200
    select 'Sim', from: 'Banheiro'
    select 'Sim', from: 'Varanda'
    select 'Sim', from: 'Ar condicionado'
    select 'Sim', from: 'Televisão'
    select 'Sim', from: 'Guarda-roupas'
    select 'Sim', from: 'Cofre'
    select 'Sim', from: 'Acessibilidade'
    click_on 'Salvar'
    
    expect(current_path).to eq guesthouse_room_path(guesthouse.id, Room.last.id)
    expect(page).to have_content 'Quarto cadastrado com sucesso.'
    expect(page).to have_content 'Detalhes do quarto Diamante'
    expect(page).to have_content 'Nome: Diamante'
    expect(page).to have_content 'Descrição: Quarto grande com duas camas de casal e uma de solteiro'
    expect(page).to have_content 'Dimensão: 20 m2'
    expect(page).to have_content 'Capacidade: 5 pessoas'
    expect(page).to have_content 'Valor da diária: R$ 200.0' # formatar valor <----------------------------------
    expect(page).to have_content 'Banheiro: Sim'
    expect(page).to have_content 'Varanda: Sim'
    expect(page).to have_content 'Ar condicionado: Sim'
    expect(page).to have_content 'Televisão: Sim'
    expect(page).to have_content 'Guarda-roupas: Sim'
    expect(page).to have_content 'Cofre: Sim'
    expect(page).to have_content 'Acessibilidade: Sim'
  end

  it "and it is not possible to register for another user's guesthouse" do 
    # Arrange
    first_host = User.create!(name: 'Andre', email: 'andre@email.com', password: 'password', role: 8)
    second_host = User.create!(name: 'Erika', email: 'erika@email.com', password: 'password', role: 8)

    first_guesthouse = Guesthouse.create!(
      brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
      email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
      postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
      usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user: first_host
    )

    second_guesthouse = Guesthouse.create!(
      brand_name: 'Resort Azul', corporate_name: 'Resort Hotel', tax_code: '17.514.160/0001-51', phone: '11 8888',
      email: 'azul@pousada.com', address: 'Rua do resort, 20', district: 'Bairro do resort', state: 'MT', city: 'Chapada dos Guimarães',
      postal_code: '80000-000', description: 'Um resort cheio de piscinas', accepts_pets: false, active: false,
      usage_policy: 'Proíbido não se divertir', check_in: '13:00', check_out: '11:00', user: second_host
    )

    # criei duas pousadas, falta logar como um user e tentar cadastrar para outro user
    # Act
    login_as second_host
    visit root_path
    visit new_guesthouse_room_path(first_guesthouse.id)
    # Assert
    
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para realizar essa ação.'
  end
end
