require 'rails_helper'

feature 'User can edit own a question' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  scenario 'Unauthenticated user cannot edit a question' do
    visit questions_path question
    within find(id: "question-#{question.id}") do
      expect(page).not_to have_link 'Edit'
    end
  end

  describe 'Authenticated user' do
    given!(:user1) { create(:user) }
    given!(:question1) { create(:question, author: user1, body: 'user1 question') }

    before { sign_in(user) }

    scenario 'can edit an own question', js: true do
      visit question_path(question)
      within find("#question-#{question.id}") do
        click_on 'Edit'
        fill_in 'Title', with: 'New Question Title'
        fill_in 'Body', with: 'New Question Body'
        click_on 'Save'

        expect(page).not_to have_content question.title
        expect(page).not_to have_content question.body
        expect(page).to have_content 'New Question Title'
        expect(page).to have_content 'New Question Body'
        expect(page).not_to have_selector 'textarea'
      end
    end

    scenario 'cannot edit an own question with invalid attributes', js: true do
      visit question_path(question)
      within find("#question-#{question.id}") do
        click_on 'Edit'
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content question.title
        expect(page).to have_content question.body
      end

      within '.question-errors' do
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'cannot edit a question that is not his own', js: true do
      visit question_path(question1)
      within find("#question-#{question1.id}") do
        expect(page).not_to have_link 'Edit'
      end
    end

    scenario 'can add files while editing the question', js: true do
      visit question_path(question)

      within find("#question-#{question.id}") do
        click_on 'Edit'

        attach_file 'File', [Rails.root.join('spec/rails_helper.rb'), Rails.root.join('spec/spec_helper.rb')]
        click_on 'Save'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'can add links while editing the question', js: true do
      visit question_path(question)

      within find("#question-#{question.id}") do
        click_on 'Edit'

        click_on 'Add link'

        fill_in 'Link name', with: 'Developer'
        fill_in 'Url', with: 'https://dev.to'

        click_on 'Save'

        expect(page).to have_link 'Developer', href: 'https://dev.to'
      end
    end
  end
end
