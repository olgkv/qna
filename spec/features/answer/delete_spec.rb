require 'rails_helper'

feature "Only an answer's author can delete it" do
  given!(:user1) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer1) { create(:answer, question: question, author: user1) }
  given!(:answer2) { create(:answer, question: question, author: user2) }

  describe 'Authenticated user' do
    before { sign_in(user1) }

    scenario 'can delete his answer', js: true do
      visit question_path(question)

      accept_alert do
        within("div#answer-#{answer1.id}") do
          click_on 'Delete'
        end
      end

      expect(page).not_to have_selector "#answer-#{answer1.id}"
      expect(page).not_to have_content answer1.body
    end

    scenario "cannot delete someone's answer", js: true do
      visit question_path(question)

      within("div#answer-#{answer2.id}") do
        expect(page).not_to have_link 'Delete'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'cannot delete the answers', js: true do
      visit question_path(question)

      within("div#answer-#{answer1.id}") do
        expect(page).not_to have_link 'Delete'
      end

      within("div#answer-#{answer2.id}") do
        expect(page).not_to have_link 'Delete'
      end
    end
  end
end
