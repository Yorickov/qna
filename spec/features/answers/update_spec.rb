# rubocop:disable Metrics/BlockLength

require 'rails_helper'

feature 'Autenticated user can edit his answer' do
  given(:user1) { create(:user_with_questions, questions_count: 1) }
  given(:user2) { create(:user_with_questions, questions_count: 1) }

  given(:user1_question) { user1.questions.first }
  given(:user2_question) { user2.questions.first }

  given!(:user1_answer) { create(:answer, question: user2_question, user: user1) }
  given!(:user2_answer) { create(:answer, question: user1_question, user: user2) }

  describe 'Authenticated user' do
    background { sign_in(user1) }

    scenario 'edits his answer', js: true do
      visit question_path(user2_question)
      click_on t('answers.answer.edit_answer')

      within '.answers' do
        fill_in t('activerecord.attributes.answer.body'), with: 'edited answer'
        click_on t('forms.submit_answer')

        expect(page).to_not have_content user1_answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors', js: true do
      visit question_path(user2_question)
      click_on t('answers.answer.edit_answer')

      within '.answers' do
        fill_in t('activerecord.attributes.answer.body'), with: ''
        click_on t('forms.submit_answer')

        expect(page).to have_content t('activerecord.errors.messages.blank')
      end
    end

    scenario "edits another's answer" do
      visit question_path(user1_question)

      expect(page).to have_content user2_answer.body
      expect(page).not_to have_content t('answers.answer.edit_answer')
    end
  end

  scenario 'Guest try to edit answer' do
    visit question_path(user1_question)

    expect(page).to have_content user2_answer.body
    expect(page).not_to have_content t('answers.answer.edit_answer')
  end
end
