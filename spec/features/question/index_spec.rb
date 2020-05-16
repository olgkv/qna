require 'rails_helper'

feature 'User can see list of questions', '
Any user can see list of questions' do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3) }

  describe 'Authenticated user do' do
    background do
      sign_in(user)
      visit questions_path
    end

    scenario 'Authenticated user can seee list of questions' do
      questions.each do |question|
        expect(page).to have_content question.title
      end
    end
  end

  describe 'Unauthenticated user do' do
    scenario 'Unauthenticated user tries to ask a question' do
      visit questions_path

      questions.each do |question|
        expect(page).to have_content question.title
      end
    end
  end
end
