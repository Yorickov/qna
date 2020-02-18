# rubocop:disable Metrics/BlockLength

require 'rails_helper'

feature 'Author can add links to his question' do
  given(:user) { create(:user) }
  given(:url) { Faker::Internet.url }
  given(:url_alt) { Faker::Internet.url }
  given(:gist_url) { 'https://gist.github.com/Yorickov/7ba1dcccfb691b5d5e6b1779bcc81e3e' }
  given(:gist_link_not_exist) { 'https://gist.github.com/Yorickov/123' }

  background do
    sign_in(user)
    visit new_question_path

    fill_in t('activerecord.attributes.question.title'), with: 'Test question'
    fill_in t('activerecord.attributes.question.body'),  with: 'question text'
  end

  describe 'User successfully' do
    scenario 'adds link when asks question' do
      fill_in t('activerecord.attributes.link.name'), with: 'My link'
      fill_in t('activerecord.attributes.link.url'), with: url

      click_on t('forms.submit_question')

      expect(page).to have_link 'My link', href: url
    end

    scenario 'adds many links when asks question', js: true do
      within('.nested-fields') do
        fill_in t('activerecord.attributes.link.name'), with: 'My gist1'
        fill_in t('activerecord.attributes.link.url'), with: url
      end

      click_on t('forms.add_link')

      within('.links>.nested-fields') do
        fill_in t('activerecord.attributes.link.name'), with: 'My gist2'
        fill_in t('activerecord.attributes.link.url'), with: url_alt
      end

      click_on t('forms.submit_question')

      expect(page).to have_link 'My gist1', href: url
      expect(page).to have_link 'My gist2', href: url_alt
    end

    scenario 'adds git-links when asks question' do
      fill_in t('activerecord.attributes.link.name'), with: 'My gist'
      fill_in t('activerecord.attributes.link.url'), with: gist_url

      click_on t('forms.submit_question')

      expect(page).to have_content 'test test test'
      expect(page).not_to have_link 'My gist', href: gist_url
    end
  end

  describe 'User' do
    scenario 'adds links when asks question with errors' do
      fill_in t('activerecord.attributes.link.name'), with: ''
      fill_in t('activerecord.attributes.link.url'), with: url

      click_on t('forms.submit_question')

      expect(page).to have_content t('activerecord.errors.messages.blank')
    end

    scenario 'adds git-link when asks question but they are no content' do
      fill_in t('activerecord.attributes.link.name'), with: 'My gist'
      fill_in t('activerecord.attributes.link.url'), with: gist_link_not_exist

      click_on t('forms.submit_question')

      expect(page).to have_content 'No such a gist'
      expect(page).not_to have_link 'My gist', href: gist_link_not_exist
    end
  end
end
