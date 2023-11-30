require 'rails_helper'

describe 'User edit guesthouse' do
  it 'from details screen' do 
    # Arrange
    host = User.create!(name: 'Andre', email: 'andre@email.com', password: 'password', role: 8)
  
    guesthouse = Guesthouse.create!(
      brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
      email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
      postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
      usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user: host
    )

    PaymentMethod.create!(name: 'Débito')
    PaymentMethod.create!(name: 'Dinheiro')

    # Act
    login_as(host)
    visit guesthouse_path(guesthouse.id)
    click_on 'Editar'
    fill_in 'Nome Fantasia', with: 'Cantinho editado'
    select 'Não', from: 'Aceita Pets'
    fill_in 'Check In', with: '13:00:00.000'
    check 'Débito'
    click_on 'Salvar'

    # Assert
    expect(current_path).to eq guesthouse_path(guesthouse.id)
    within('h2') { expect(page).to have_content 'Detalhes da Pousada' }
    expect(page).to have_content 'Pousada atualizada com sucesso'
    expect(page).to have_content 'Nome: Cantinho editado'
    expect(page).to have_content 'Não aceita pets'
    expect(page).to have_content 'Check In: 13:00'
    expect(page).to have_content 'Forma de Pagamento: Débito'
    expect(page).not_to have_content 'Dinheiro'
  end

  it 'only if user is the owner' do 
    # Arrange
    first_host = User.create!(name: 'Andre', email: 'andre@email.com', password: 'password', role: 8)
    second_host = User.create!(name: 'Erika', email: 'erika@email.com', password: 'password', role: 8)

    guesthouse = Guesthouse.create!(
      brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
      email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
      postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
      usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user: first_host
    )

    Guesthouse.create!(
      brand_name: 'Resort Azul', corporate_name: 'Resort Hotel', tax_code: '17.514.160/0001-51', phone: '11 8888',
      email: 'azul@pousada.com', address: 'Rua do resort, 20', district: 'Bairro do resort', state: 'MT', city: 'Chapada dos Guimarães',
      postal_code: '80000-000', description: 'Um resort cheio de piscinas', accepts_pets: false, active: false,
      usage_policy: 'Proíbido não se divertir', check_in: '13:00', check_out: '11:00', user: second_host
    )

    # Act
    login_as(second_host)
    visit edit_guesthouse_path(guesthouse.id)

    # Assert
    expect(current_path).not_to eq edit_guesthouse_path(guesthouse.id)
    expect(page).to have_content('Você não tem permissão para realizar essa ação.')
  end

  it 'but only sees the edit link if is the owner' do 
    # Arrange
    first_host = User.create!(name: 'Andre', email: 'andre@email.com', password: 'password', role: 8)
    second_host = User.create!(name: 'Erika', email: 'erika@email.com', password: 'password', role: 8)

    guesthouse = Guesthouse.create!(
      brand_name: 'Cantinho no mato', corporate_name: 'Pousada XYZ', tax_code: '25.443.218/0001-41', phone: '11 9999',
      email: 'xyz@pousada.com', address: 'Rua do xyz, 10', district: 'Bairro do xyz', state: 'MT', city: 'Campo Verde',
      postal_code: '78840-000', description: 'Uma pousada no meio do mato', accepts_pets: true, active: true,
      usage_policy: 'Uma política de uso bem legal', check_in: '14:00', check_out: '12:00', user: first_host
    )

    Guesthouse.create!(
      brand_name: 'Resort Azul', corporate_name: 'Resort Hotel', tax_code: '17.514.160/0001-51', phone: '11 8888',
      email: 'azul@pousada.com', address: 'Rua do resort, 20', district: 'Bairro do resort', state: 'MT', city: 'Chapada dos Guimarães',
      postal_code: '80000-000', description: 'Um resort cheio de piscinas', accepts_pets: false, active: false,
      usage_policy: 'Proíbido não se divertir', check_in: '13:00', check_out: '11:00', user: second_host
    )

    # Act
    login_as(second_host)
    visit guesthouse_path(guesthouse)

    # Assert
    expect(page).not_to have_link('Editar', href: edit_guesthouse_path(guesthouse.id))
  end
end
