require 'rails_helper'

feature 'User can add links to answer' do
  given(:user) { create(:user_with_questions, questions_count: 1) }
  given(:question) { user.questions.first }
  given(:gist_url) { 'https://gist.github.com/Yorickov/1089ef9c3e0fc1e3b0be04dc85e1612e' }

  scenario 'User adds link when asks question', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in t('activerecord.attributes.answer.body'), with: 'answer text'

    fill_in t('activerecord.attributes.link.name'), with: 'My gist'
    fill_in t('activerecord.attributes.link.url'), with: gist_url

    click_on t('forms.submit_answer')

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
