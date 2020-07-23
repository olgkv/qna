require 'rails_helper'

feature 'User can see the question and its answers' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }
  given!(:gist_link) { create(:link, linkable: question, url: 'https://gist.github.com/JoshCheek/91133b3703c10b135cd42c331f89e700') }

  describe 'Authenticated user' do
    scenario 'Can see the question and its answers' do
      sign_in(user)
      visit question_path question

      expect(page).to have_current_path question_path(question)
      expect(page).to have_content question.title
      expect(page).to have_content question.body
      answers.each { |answer| expect(page).to have_content answer.body }
    end

    scenario 'With a gist link can see a gist content immediately' do

      visit question_path(question)

      expect(page).to have_content 'Continuous integration'
      expect(page).to have_content 'Trust test suite'
    end
  end

  scenario 'Unauthenticated user can see the question and its answers' do
    visit question_path question

    expect(page).to have_current_path question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each { |answer| expect(page).to have_content answer.body }
  end
end
