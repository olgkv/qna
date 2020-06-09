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
    end

    scenario 'can answer the question', js: true do
      expect(page).to have_current_path(question_path(question))

      fill_in 'Body', with: 'Good. Answer body text'

      click_on 'Answer'

      expect(page).to have_content 'Good. Answer body text'
    end

    scenario 'Cannot answer the question with a blank body', js: true do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'can add files to answer', js: true do
      fill_in 'Body', with: 'answer body'

      attach_file 'File', [Rails.root.join('spec/rails_helper.rb'), Rails.root.join('spec/spec_helper.rb')]
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'Cannot answer the question' do
      visit question_path question
      click_on 'Answer'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
