require 'rails_helper'

feature 'User can vote for the answer', js: true do
  given(:user) { create(:user) }
  given(:user1) { create(:user) }
  given!(:answer) { create(:answer, author: user) }

  context 'when an authenticated user' do
    background do
      sign_in(user1)
      visit question_path(answer.question)
    end

    scenario 'can vote up' do
      within find("#answer-#{answer.id}") do
        click_on 'Vote up'
      end

      expect(page).to have_content '1'
    end

    scenario 'can vote down' do
      within find("#answer-#{answer.id}") do
        click_on 'Vote down'
      end

      # save_and_open_page

      expect(page).to have_content '-1'
    end

    scenario 'cannot vote more than once' do
      within find("#answer-#{answer.id}") do
        2.times { click_on 'Vote up' }
        2.times { click_on 'Vote down' }

        expect(page).to have_content '1'
      end
    end

    scenario 'can cancel his/her own vote' do
      within find("#answer-#{answer.id}") do
        click_on 'Vote up'
        click_on 'Cancel vote'

        expect(page).to have_content '0'
      end
    end
  end

  context 'when an unauthenticated user' do
    scenario 'cannot vote' do
      visit question_path(answer.question)

      within find("#answer-#{answer.id}") do
        expect(page).not_to have_link 'Vote up'
        expect(page).not_to have_link 'Vote down'
      end
    end
  end
end
