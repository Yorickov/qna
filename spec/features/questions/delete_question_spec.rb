require 'rails_helper'

feature 'Autenticated user can delete only his question' do
  given(:user1) { build(:user_with_questions) }
  given(:user2) { build(:user_with_questions) }

  describe "Question's author try to delete" do
    background { sign_in(user1) }

    scenario 'His question' do
      question = user1.questions.first
      visit question_path(question)

      expect(page).to have_content question.title

      click_on t('questions.show.delete_question')

      expect(page).not_to have_content question.title
      expect(page).to have_content t('questions.destroy.success')
    end

    scenario "Another's question" do
      visit question_path(user2.questions.first)

      expect(page).not_to have_content t('questions.show.delete_question')
    end
  end

  scenario "Guest can't delete question" do
    visit question_path(user2.questions.first)

    expect(page).not_to have_content t('questions.show.delete_question')
  end
end
