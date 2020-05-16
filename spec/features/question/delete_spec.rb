require 'rails_helper'

feature 'An author of the question can delete the own question' do
  background { visit questions_path }

  describe 'Authenticated user' do
    given(:user1) { create(:user) }
    given(:user2) { create(:user) }
    given(:question1) { create(:question, author: user1) }
    given(:question2) { create(:question, author: user2) }

    before { sign_in(user1) }

    scenario 'can delete the own question' do
      visit question_path(question1)

      click_on 'Delete'

      expect(page).to have_content 'Question was successfully deleted'
    end

    scenario "cannot delete someone's question" do
      visit question_path(question2)

      expect(page).not_to have_link 'Delete'
    end
  end
end
