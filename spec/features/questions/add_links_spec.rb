# rubocop:disable Metrics/BlockLength

require 'rails_helper'

feature 'User can add links to question' do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/Yorickov/1089ef9c3e0fc1e3b0be04dc85e1612e' }

  scenario 'User adds links when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in t('activerecord.attributes.question.title'), with: 'Test question'
    fill_in t('activerecord.attributes.question.body'),  with: 'question text'

    fill_in t('activerecord.attributes.link.name'), with: 'My gist'
    fill_in t('activerecord.attributes.link.url'), with: gist_url

    click_on t('forms.submit_question')

    expect(page).to have_link 'My gist', href: gist_url
  end
end
