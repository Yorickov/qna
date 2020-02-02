# rubocop:disable Metrics/BlockLength

require 'rails_helper'

feature 'Autenticated user can delete only his answers' do
  given(:user1) { create(:user_with_questions) }
  given(:user2) { create(:user_with_questions) }
  given(:user1_question) { user1.questions.first }
  given(:user2_question) { user2.questions.first }

  describe "Answer's author try to delete" do
    background do
      sign_in(user1)

      create(:answer, question: user2_question, user: user1)
      create(:answer, question: user1_question, user: user2)
    end

    scenario 'His answer' do
      answer = user1.answers.first
      visit question_path(user2_question)

      expect(page).to have_content answer.body

      click_on t('answers.answer.delete_answer')

      expect(page).not_to have_content answer.body
      expect(page).to have_content t('answers.destroy.success')
    end

    scenario "Another's answer" do
      visit question_path(user1_question)

      expect(page).not_to have_content t('answers.answer.delete_answer')
    end
  end

  scenario 'Guest try to delete answer' do
    create(:answer, question: user1_question, user: user1)

    visit question_path(user1_question)

    expect(page).not_to have_content t('answers.answer.delete_answer')
  end
end
