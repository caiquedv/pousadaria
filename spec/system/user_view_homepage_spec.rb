require 'rails_helper'

describe 'User visits home page' do 
  it 'and sees the app name as title linking to home' do 
    # Arrange

    # Act        
    visit ('/')

    # Assert
    within('h1') { expect(page).to have_link('InnSight', href: root_path) }
  end
end