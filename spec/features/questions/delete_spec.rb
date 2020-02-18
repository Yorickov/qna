require 'rails_helper'

feature 'Autenticated user can delete only his question' do
  given(:user1) { create(:user_with_questions) }
  given(:user2) { create(:user_with_questions) }
  given(:user1_question) { user1.questions.first }

  describe "Question's author try to delete" do
    background { sign_in(user1) }

    scenario 'His question' do
      visit question_path(user1_question)

      expect(page).to have_content user1_question.title

      click_on t('questions.question_body.delete_question')

      expect(page).not_to have_content user1_question.title
      expect(page).to have_content t('questions.destroy.success')
    end

    scenario "another's question" do
      visit question_path(user2.questions.first)

      within '.question-node' do
        expect(page).not_to have_link t('questions.question_body.delete_question')
      end
    end
  end

  scenario 'Guest try to delete question' do
    visit question_path(user1_question)

    within '.question-node' do
      expect(page).not_to have_link t('questions.question_body.delete_question')
    end
  end
end
