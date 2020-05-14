require 'rails_helper'

feature 'User can sign out' do
  given(:user) { create(:user) }

  scenario 'Authenticated user can sign out' do
    sign_in(user)
    visit questions_path

    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully'
    expect(page).to have_content 'Log in'
  end
end
