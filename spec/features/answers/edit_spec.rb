# rubocop:disable Metrics/BlockLength

require 'rails_helper'

feature 'Autenticated user can edit his answer' do
  given(:user1) { create(:user_with_questions, questions_count: 1) }
  given(:user2) { create(:user_with_questions, questions_count: 1) }
  given(:user1_question) { user1.questions.first }
  given(:user2_question) { user2.questions.first }

  describe 'Authenticated user' do
    background do
      sign_in(user1)

      create(:answer, question: user2_question, user: user1)
      create(:answer, question: user1_question, user: user2)
    end

    scenario 'edits his answer', js: true do
      answer = user1.answers.first
      visit question_path(user2_question)

      click_on t('answers.answer.edit_answer')

      within '.answers' do
        fill_in t('activerecord.attributes.answer.body'), with: 'edited answer'
        click_on t('forms.submit_answer')

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors'
    scenario "edits another's answer"
  end

  scenario 'Guest try to edit answer' do
    visit question_path(user1_question)

    expect(page).not_to have_content t('answers.answer.edit_answer')
  end
end
