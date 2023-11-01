require 'rails_helper'

describe 'User authenticates' do
  it 'successfully' do
    # Arrange

    # Act
    visit root_path
    click_on 'Entrar'
    click_on 'Criar conta'
    fill_in 'Nome', with: 'Maria'
    select 'Anfitrião', from: 'Tipo de conta'
    fill_in 'E-mail', with: 'maria@email.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Criar conta'

    # Assert
    expect(page).to have_content 'Boas Vindas! Cadastro realizado com sucesso.'
    expect(page).to have_content 'maria@email.com'
    expect(page).to have_content 'Anfitrião'
    expect(page).to have_button 'Sair'
    user = User.last
    expect(user.name).to eq 'Maria'
  end

  it 'with incomplete data' do
    # Arrange

    # Act
    visit root_path
    click_on 'Entrar'
    click_on 'Criar conta'
    fill_in 'Nome', with: ''
    fill_in 'E-mail', with: ''
    fill_in 'Senha', with: ''
    click_on 'Criar conta'

    # Assert
    expect(page).to have_content 'Não foi possível salvar usuário'
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'Senha não pode ficar em branco'
    expect(page).to have_content 'Nome não pode ficar em branco'
  end

  it 'with shorter password length' do
    # Arrange

    # Act
    visit root_path
    click_on 'Entrar'
    click_on 'Criar conta'
    fill_in 'Senha', with: '1'
    click_on 'Criar conta'

    # Assert
    expect(page).to have_content 'Não foi possível salvar usuário'
    expect(page).to have_content 'Senha mínimo 6 caracteres'
    expect(page).to have_content 'Confirme sua senha não é igual a Senha'
  end
end
