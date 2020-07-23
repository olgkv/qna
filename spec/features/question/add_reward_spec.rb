require 'rails_helper'

feature 'User can add a reward', %(
When creating a question
The user can add a reward
for the best answer
) do
  given(:user) { create(:user) }

  scenario 'User can add reward', js: true do
    sign_in(user)
    visit new_question_path

    within('.question-form') do
      fill_in 'Title', with: 'question title'
      fill_in 'Body', with: 'question body'
    end

    within('.reward-form') do
      fill_in 'Title', with: 'Reward title'
      attach_file 'Image', Rails.root.join('spec/rails_helper.rb')
    end

    click_on 'Ask'

    expect(user.questions.last.reward).to be_a(Reward)
  end
end
