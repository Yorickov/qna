require 'rails_helper'

feature 'User can create question' do
  given(:user) { build(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on t('shared.navi.ask_question')
    end

    scenario 'Asks a question' do
      fill_in t('activerecord.attributes.question.title'),
              with: 'Test question'
      fill_in t('activerecord.attributes.question.body'),
              with: 'question text'
      click_on t('forms.submit')

      expect(page).to have_content t('questions.create.success')
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'question text'
    end

    scenario 'Asks a question with errors' do
      click_on t('forms.submit')

      expect(page).to have_content t('activerecord.errors.messages.blank')
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on t('shared.navi.ask_question')

    expect(page).to have_content t('devise.failure.unauthenticated')
  end
end

# feature 'Guest can create question' do
#   background do
#     visit questions_path
#     click_on t('shared.navi.ask_question')
#   end

#   scenario 'Asks a question' do
#     fill_in t('activerecord.attributes.question.title'),
#             with: 'Test question'
#     fill_in t('activerecord.attributes.question.body'),
#             with: 'question text'
#     click_on t('forms.submit')

#     expect(page).to have_content t('questions.create.success')
#     expect(page).to have_content 'Test question'
#     expect(page).to have_content 'question text'
#   end

#   scenario 'Asks a question with errors' do
#     click_on t('forms.submit')

#     expect(page).to have_content t('activerecord.errors.messages.blank')
#   end
# end
