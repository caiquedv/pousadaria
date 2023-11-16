require 'rails_helper'

describe 'User authenticates' do
  it 'successfully' do
    # Arrange
    User.create!(name: 'Joao Silva', email: 'joao@email.com', password: 'password')
    
    # Act
    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail', with: 'joao@email.com'
    fill_in 'Senha', with: 'password'
    click_on 'Login'

    # Assert
    expect(page).to have_content 'Login efetuado com sucesso.'
    within('nav') do
      expect(page).not_to have_link 'Entrar'
      expect(page).to have_button 'Sair'
      expect(page).to have_content 'Joao Silva - joao@email.com - Hóspede'
    end
  end
  
  it 'and do logout' do
    # Arrange
    User.create!(name: 'João', email: 'joao@email.com', password: 'password')
    
    # Act
    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail', with: 'joao@email.com'
    fill_in 'Senha', with: 'password'
    click_on 'Login'
    click_on 'Sair'
  
    # Assert
    expect(page).to have_content 'Logout efetuado com sucesso.'
    expect(page).to have_link 'Entrar'
    expect(page).not_to have_button 'Sair'
    expect(page).not_to have_content 'joao@email.com'
  end
  
end
