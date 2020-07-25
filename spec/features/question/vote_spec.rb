require 'rails_helper'

feature 'User can vote for the question', js: true do
  given(:user) { create(:user) }
  given(:user1) { create(:user) }
  given!(:question) { create(:question, author: user) }

  context 'when an authenticated user' do
    background do
      sign_in(user1)
      visit question_path(question)
    end

    scenario 'can vote up' do
      within find("#question-#{question.id}") do
        click_on 'Vote up'
      end

      expect(page).to have_content '1'
    end

    scenario 'can vote down' do
      within find("#question-#{question.id}") do
        click_on 'Vote down'
      end

      expect(page).to have_content '-1'
    end
  end
end
