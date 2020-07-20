require 'rails_helper'

feature 'User can delete link', "
  In order to make changes
  As an author of question
  I'd like to be able to delete links
" do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:question_link) { create(:link, :of_question, linkable: question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can delete a link' do
      within "#question-#{question.id}" do
        expect(page).to have_link question_link.name, href: question_link.url

        page.accept_confirm do
          click_on 'Delete link'
        end
      end

      within "#question-#{question.id}" do
        expect(page).not_to have_link question_link.name
      end
    end
  end

  scenario "cannot delete the other author's link" do
    sign_in(other_user)
    visit question_path(question)

    expect(page).not_to have_link 'Delete link'
  end

  describe 'Unauthenticated user', js: true do
    scenario 'Cannot delete the link', js: true do
      visit question_path(question)

      expect(page).not_to have_link 'Delete link'
    end
  end
end
