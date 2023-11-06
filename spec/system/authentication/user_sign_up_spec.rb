require 'rails_helper'

describe 'User authenticates' do
  context 'as host' do
    it 'successfully and is redirected to create a new guesthouse' do
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
      expect(current_path).to eq new_guesthouse_path
      expect(page).to have_content 'Boas Vindas! Cadastro realizado com sucesso.'
      expect(page).to have_content 'Maria - maria@email.com - Anfitrião'      
      expect(page).to have_button 'Sair'     
    end    
  end  

  context 'as guest' do
    it 'successfully and is redirected to root' do
      # Arrange
  
      # Act
      visit root_path
      click_on 'Entrar'
      click_on 'Criar conta'
      fill_in 'Nome', with: 'Maria'
      select 'Hóspede', from: 'Tipo de conta'
      fill_in 'E-mail', with: 'maria@email.com'
      fill_in 'Senha', with: 'password'
      fill_in 'Confirme sua senha', with: 'password'
      click_on 'Criar conta'
  
      # Assert
      expect(current_path).to eq root_path
      expect(page).to have_content 'Boas Vindas! Cadastro realizado com sucesso.'
      expect(page).to have_content 'Maria - maria@email.com - Hóspede'      
      expect(page).to have_button 'Sair'      
    end    
  end  
  
  context 'with data errors:' do
    it 'incomplete data' do
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
    
    it 'shorter password length' do
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

end
