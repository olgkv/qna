require 'rails_helper'

feature 'User can sign in', "
In order to ask questions
As an unauthorized user
I'd like to be able to sign in
" do
  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Enter'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregisterd user tries to sing in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '123456789'
    click_on 'Enter'

    expect(page).to have_content 'Invalid Email or password'
  end
end
