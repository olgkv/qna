require 'rails_helper'

feature 'User can delete link', "
  In order to make changes
  As an author of an answer
  I'd like to be able to delete links
" do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:answer_link) { create(:link, :of_answer, linkable: answer) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can delete a link' do
      within "#answer-#{answer.id}" do
        expect(page).to have_link answer_link.name, href: answer_link.url

        page.accept_confirm do
          click_on 'Delete link'
        end
      end

      within "#answer-#{answer.id}" do
        expect(page).not_to have_link answer_link.name
      end
    end
  end

  scenario "cannot to delete the other author's link" do
    sign_in(other_user)
    visit question_path(question)

    expect(page).not_to have_link 'Delete link'
  end

  scenario 'Unauthenticated user cannot to delete link', js: true do
    visit question_path(question)

    expect(page).not_to have_link 'Delete link'
  end
end
