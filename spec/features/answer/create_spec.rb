require 'rails_helper'

feature 'User can create an answer to the question', "
  In order to answer the question
  As an authenticated user
  I'd like to be able to create an answer to the question without leaving the selected question page
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
      click_on 'Answer the question'
    end

    scenario 'Answer the question' do
      fill_in 'Body', with: 'Good. Answer body text'
      click_on 'Answer'

      expect(page).to have_content 'Your answer was successfully created'
      expect(page).to have_content 'Good. Answer body text'
    end

    scenario 'Cannot answer the question with a blank body' do
      click_on 'Answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Unauthenticated user' do
    scenario 'Cannot answer the question' do
      visit question_path question

      fill_in 'Body', with: 'Test answer body text'
      click_on 'Answer'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
