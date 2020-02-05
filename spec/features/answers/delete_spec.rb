require 'rails_helper'

feature 'Autenticated user can delete only his answers' do
  given(:user1) { create(:user_with_questions, questions_count: 1) }
  given(:user2) { create(:user_with_questions, questions_count: 1) }

  given(:user1_question) { user1.questions.first }
  given(:user2_question) { user2.questions.first }

  given!(:user1_answer) { create(:answer, question: user2_question, user: user1) }
  given!(:user2_answer) { create(:answer, question: user1_question, user: user2) }

  describe "Answer's author try to delete" do
    background { sign_in(user1) }

    scenario 'His answer', js: true do
      visit question_path(user2_question)

      expect(page).to have_content user1_answer.body

      click_on t('answers.answer.delete_answer')

      expect(page).not_to have_content user1_answer.body
    end

    scenario "Another's answer", js: true do
      visit question_path(user1_question)

      expect(page).to have_content user2_answer.body
      expect(page).not_to have_content t('answers.answer.delete_answer')
    end
  end

  scenario 'Guest try to delete answer', js: true do
    visit question_path(user1_question)

    expect(page).to have_content user2_answer.body
    expect(page).not_to have_content t('answers.answer.delete_answer')
  end
end
