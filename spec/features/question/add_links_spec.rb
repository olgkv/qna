require 'rails_helper'

feature 'User can add links to question', "
In order to provide additional info to my question
As an question's author
I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/JoshCheek/91133b3703c10b135cd42c331f89e700' }
  given(:gist_url_invalid) { 'hps://gist.github.com/JoshCheek/91133b3703c10b135cd42c331f89e700' }

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end

  scenario 'User adds multiple links when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    2.times { click_on 'Add link' }

    all('.nested-fields').each do |link_field|
      within(link_field) do
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url
      end
    end

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url, count: 3
  end

  scenario 'User cannot add invalid link', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url_invalid

    click_on 'Ask'

    expect(page).not_to have_link 'My gist', href: gist_url_invalid
    expect(page).to have_content 'URL is invalid'
  end
end
