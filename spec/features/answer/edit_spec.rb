require 'rails_helper'

feature 'User can edit the answer', "
  In Order to correct mistakes
  As an author of answer
  I'd like to be able to edit my anser" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end

  describe 'Authenticated user' do
    given!(:user1) { create(:user) }
    given!(:answer1) { create(:answer, question: question, author: user1) }

    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits his answer', js: true do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Body', with: 'edited answer'
        click_on 'Save'

        expect(page).not_to have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).not_to have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors', js: true do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'
        expect(page).to have_content answer.body
      end

      within '.answers-errors' do
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's question", js: true do
      within '.answers' do
        within find(id: "answer-#{answer1.id}") do
          expect(page).not_to have_link 'Edit'
        end
      end
    end
  end
end
