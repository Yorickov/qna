require 'rails_helper'

feature 'Authenticated user can create answer' do
  given(:user) { create(:user_with_questions) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(user.questions.first)
    end

    scenario 'Create Answer' do
      fill_in t('activerecord.attributes.answer.body'), with: 'answer text'
      click_on t('forms.submit_answer')

      expect(page).to have_content t('answers.create.success')
      expect(page).to have_content 'answer text'
    end

    scenario 'Create Answer with errors' do
      click_on t('forms.submit_answer')

      expect(page).to have_content t('activerecord.errors.messages.blank')
    end
  end

  scenario 'Unauthenticated user tries to create a answer' do
    visit question_path(user.questions.first)

    expect(page).not_to have_content t('forms.submit_answer')
  end
end
