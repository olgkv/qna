require 'rails_helper'

feature 'Author can delete attached files', '
  The author of the question
  Can delete any files, that are
  Attached to the question
' do
  given(:user) { create(:user) }
  given(:user1) { create(:user) }
  given(:question) { create(:question, author: user) }

  context 'when author', js: true do
    background do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit'

      within find("#question-#{question.id}") do
        fill_in 'Title', with: 'question title'
        fill_in 'Body', with: 'question body'
        attach_file 'File', [Rails.root.join('spec/rails_helper.rb')]

        click_on 'Save'
      end
    end

    scenario 'it has file' do
      expect(page).to have_content 'rails_helper.rb'
    end

    scenario "can delete question's files" do
      click_on 'Delete file'

      expect(page).not_to have_content 'rails_helper.rb'
    end
  end

  context 'when unauthenticated user', js: true do
    scenario "tries to delete quesiton's files" do
      visit question_path(question)
      expect(page).not_to have_content 'Delete file'
    end
  end

  context 'when non-author', js: true do
    scenario "tries to delete question's files" do
      file = fixture_file_upload(Rails.root.join('spec/spec_helper.rb'))
      question1 = create(:question, author: user, files: [file])
      sign_in(user1)
      visit question_path(question1)

      expect(page).not_to have_content 'Delete file'
    end
  end
end
