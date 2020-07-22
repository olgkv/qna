require 'rails_helper'

feature 'User can create question', "
In order to get answer from a community
As an authenticated user
I'd like to be able to ask the question
" do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path

      click_on 'Ask question'
    end

    scenario 'Authenticated user asks a question' do
      within('.question-form') do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
      end

      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'Authenticated user asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attached files' do
      within('.question-form') do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
      end

      attach_file 'File', [Rails.root.join('spec/rails_helper.rb'), Rails.root.join('spec/spec_helper.rb')]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'asks a question with a reward' do
      within('.question-form') do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
      end

      within('.reward-form') do
        fill_in 'Title', with: 'RewardName'
      end

      attach_file 'Image', Rails.root.join('spec/rails_helper.rb')
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created'
      expect(page).to have_content 'RewardName'
      expect(page).to have_css("img[src*='rails_helper.rb']")
    end
  end

  describe 'Unauthenticated user' do
    scenario 'Unauthenticated user tries to ask a question' do
      visit questions_path
      click_on 'Ask question'

      expect(page).to have_content 'You need to sign in or sign up before continuing'
    end
  end
end
