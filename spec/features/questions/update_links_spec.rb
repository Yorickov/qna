# rubocop:disable Metrics/BlockLength

require 'rails_helper'

feature 'Author can update links in his question' do
  given(:user1) { create(:user_with_questions, questions_count: 1) }
  given(:user2) { create(:user_with_questions) }
  given(:question) { user1.questions.first }
  given!(:url) { Faker::Internet.url }

  given!(:link) { create(:link, linkable: question) }

  describe 'User' do
    background { sign_in(user1) }
    background do
      visit question_path(question)
      click_on t('questions.question_body.edit_question')
    end

    scenario 'edits his question by adding link', js: true do
      within '.question-links' do
        expect(page).to have_link link.name, href: link.url
        expect(page).not_to have_link 'My ref1', href: url
      end

      within '.question-form-node' do
        click_on t('forms.add_link')
      end

      within '.links>.nested-fields' do
        fill_in t('activerecord.attributes.link.name'), with: 'My ref1'
        fill_in t('activerecord.attributes.link.url'), with: url
      end

      click_on t('forms.submit_question')

      within '.question-links' do
        expect(page).to have_link link.name, href: link.url
        expect(page).to have_link 'My ref1', href: url
      end
    end

    scenario 'edits his question by deleting current link and adding new one', js: true do
      within '.question-links' do
        expect(page).to have_link link.name, href: link.url
      end

      within '.question-form-node' do
        click_on t('forms.remove_link')
        click_on t('forms.add_link')
      end

      within '.links>.nested-fields' do
        fill_in t('activerecord.attributes.link.name'), with: 'My ref1'
        fill_in t('activerecord.attributes.link.url'), with: url
      end

      click_on t('forms.submit_question')

      within '.question-links' do
        expect(page).not_to have_link link.name, href: link.url
        expect(page).to have_link 'My ref1', href: url
      end
    end
  end
end
