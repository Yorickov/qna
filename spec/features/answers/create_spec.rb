# rubocop:disable Metrics/BlockLength

require 'rails_helper'

feature 'Authenticated user can create answer' do
  given(:user) { create(:user_with_questions) }
  given(:question) { user.questions.first }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Create Answer', js: true do
      fill_in t('activerecord.attributes.answer.body'), with: 'answer text'
      click_on t('forms.submit_answer')

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'answer text'
      end
    end

    scenario 'Create Answer with errors', js: true do
      click_on t('forms.submit_answer')

      expect(page).to have_content t('activerecord.errors.messages.blank')
    end
  end

  scenario 'Unauthenticated user tries to create a answer', js: true do
    visit question_path(question)

    expect(page).not_to have_content t('forms.submit_answer')
  end

  scenario 'Authenticated user creates answer with errors', js: true do
    sign_in(user)

    visit question_path(question)
    click_on t('forms.submit_answer')

    expect(page).to have_content t('activerecord.errors.messages.blank')
  end
end
