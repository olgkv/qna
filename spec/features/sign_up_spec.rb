require 'rails_helper'

feature 'User can sign up' do
  background do
    visit root_path
    click_link 'Sign up'
  end

  scenario 'a new user can reate an account with valid attributes' do
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_button 'Sign up'

    expect(page).to have_content 'You have signed up successfully'
  end

  scenario 'a new user cannot create an account with invalid attributes' do
    click_button 'Sign up'
    expect(page).to have_content "Email can't be blank"
  end
end
