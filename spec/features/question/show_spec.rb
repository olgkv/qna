require 'rails_helper'

feature 'User can see the question and its answers' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  scenario 'Authenticated user can see the question and its answers' do
    sign_in(user)
    visit question_path question

    expect(page).to have_current_path question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each { |answer| expect(page).to have_content answer.body }
  end

  scenario 'Unauthenticated user can see the question and its answers' do
    visit question_path question

    expect(page).to have_current_path question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each { |answer| expect(page).to have_content answer.body }
  end
end
