require 'rails_helper'

feature 'An author of the question can choose the best answer' do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer1) { create(:answer, question: question) }
  given!(:answer2) { create(:answer, question: question) }
  given!(:answer3) { create(:answer, question: question) }
  given(:question_with_reward) { create(:question, :with_reward, author: user) }
  given!(:rewarded_answer) { create(:answer, question: question_with_reward, author: other_user) }

  context 'when authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    describe 'as an author of the question' do
      scenario 'can select best answer for the question' do
        within find("#answer-#{answer1.id}") do
          click_on 'Best'
        end

        expect(page).to have_selector '.best-answer'

        within '.best-answer' do
          expect(page).to have_content answer1.body
        end
      end

      scenario 'can select another_answer as the best' do
        within find("#answer-#{answer1.id}") do
          click_on 'Best'
        end

        within find("#answer-#{answer3.id}") do
          click_on 'Best'
        end

        expect(page).to have_selector '.best-answer'

        within '.best-answer' do
          expect(page).to have_content answer3.body
          expect(page).not_to have_content answer1.body
        end
      end

      scenario 'with reward' do
        visit question_path(question_with_reward)

        within "#answer-#{rewarded_answer.id}" do
          click_on 'Best'
        end

        click_on 'Log out'

        sign_in(other_user)

        click_on 'My rewards'

        expect(page).to have_content question_with_reward.title
        expect(page).to have_content question_with_reward.reward.title
        expect(page.find('img')['src']).to have_content question_with_reward.reward.image.filename.to_s
      end
    end
  end

  context 'when an unauthenticated user' do
    scenario 'Unauthenticated user tries to select best answer for the question', js: true do
      visit question_path(question)
      expect(page).not_to have_link 'Best'
    end
  end
end
