# rubocop:disable Metrics/BlockLength

require 'rails_helper'

feature 'Only author can edit his question' do
  given(:user1) { create(:user_with_questions, questions_count: 1) }
  given(:user2) { create(:user_with_questions, questions_count: 1) }
  given(:user1_question) { user1.questions.first }
  given(:user2_question) { user2.questions.first }

  describe 'Authenticated user' do
    background { sign_in(user1) }

    scenario 'edits his question', js: true do
      visit question_path(user1_question)
      click_on t('questions.show.edit_question')

      within '.question-node' do
        fill_in t('activerecord.attributes.question.title'), with: 'edited title'
        fill_in t('activerecord.attributes.question.body'), with: 'edited body'
        click_on t('forms.submit_question')

        expect(page).to_not have_content user1_question.title
        expect(page).to_not have_content user1_question.body
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors', js: true do
      visit question_path(user1_question)
      click_on t('questions.show.edit_question')

      fill_in t('activerecord.attributes.question.title'), with: 'edited title'
      fill_in t('activerecord.attributes.question.body'), with: ''
      click_on t('forms.submit_question')

      expect(page).to have_content t('activerecord.errors.messages.blank')
    end

    scenario "edits another's question", js: true do
      visit question_path(user2_question)

      expect(page).to have_content user2_question.body
      expect(page).not_to have_content t('questions.show.edit_question')
    end
  end

  scenario 'Guest try to edit answer', js: true do
    visit question_path(user1_question)

    expect(page).to have_content user1_question.body
    expect(page).not_to have_content t('questions.show.edit_question')
  end
end
