require 'rails_helper'

feature 'User can create comment' do
  given(:user) { create(:user_with_questions) }
  given(:question) { user.questions.first }
  given!(:answer) { create(:answer, user: user, question: question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'makes comment' do
      within '.answers' do
        fill_in t('activerecord.attributes.comment.body'), with: 'Test comment'
        click_on t('forms.submit_comment')

        expect(page).to have_content 'Test comment'
      end
    end

    scenario 'makes comment with errors' do
      within '.answers' do
        click_on t('forms.submit_comment')

        expect(page).to have_content t('activerecord.errors.messages.blank')
      end
    end
  end

  describe 'As a Guest', js: true do
    scenario 'tries to make a comment' do
      visit question_path(question)

      within '.answers' do
        expect(page).not_to have_content t('shared.navi.add_comment')
      end
    end
  end
end
