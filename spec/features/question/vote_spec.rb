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

    scenario 'cannot vote more than once' do
      within find("#question-#{question.id}") do
        2.times { click_on 'Vote up' }
        2.times { click_on 'Vote down' }

        expect(page).to have_content '1'
      end
    end

    scenario 'can cancel his/her own vote' do
      within find("#question-#{question.id}") do
        click_on 'Vote up'
        click_on 'Cancel vote'

        expect(page).to have_content '0'
      end
    end
  end

  context 'when an unauthenticated user' do
    scenario 'cannot vote' do
      visit question_path(question)

      within find("#question-#{question.id}") do
        expect(page).not_to have_link 'Vote up'
        expect(page).not_to have_link 'Vote down'
      end
    end
  end
end
