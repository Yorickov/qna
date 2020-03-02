require 'rails_helper'

feature 'User can create comment' do
  given(:user) { create(:user_with_questions) }
  given(:question) { user.questions.first }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'makes comment' do
      fill_in t('activerecord.attributes.comment.body'), with: 'Test comment'
      click_on t('forms.submit_comment')

      expect(page).to have_content 'Test comment'
    end

    scenario 'makes comment with errors' do
      click_on t('forms.submit_comment')

      expect(page).to have_content t('activerecord.errors.messages.blank')
    end
  end

  describe 'As a Guest', js: true do
    scenario 'tries to make a comment' do
      visit question_path(question)

      expect(page).not_to have_content t('shared.navi.add_comment')
    end
  end
end
