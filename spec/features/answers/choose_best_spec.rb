require 'rails_helper'

feature 'User can choose one answer to his question as the best and redo' do
  given(:user1) { create(:user_with_questions, questions_count: 1) }
  given(:user2) { create(:user_with_questions, questions_count: 1) }
  given(:user1_question) { user1.questions.first }
  given(:user2_question) { user2.questions.first }

  given!(:user1_answer) { create(:answer, question: user1_question, user: user1) }
  given!(:user2_answer) { create(:answer, question: user1_question, user: user2) }

  describe 'Authenticated user' do
    scenario 'Picks best answer, then picks another anwer', js: true do
      sign_in(user1)

      visit question_path(user1_question)

      within('.answers>.card:first-child') do
        expect(page).to have_content user1_answer.body
        expect(page).not_to have_selector(:css, '.best-answer')
        expect(page).to have_selector(:css, '.best-answer-link')
      end

      within('.answers>.card:last-child') do
        expect(page).to have_content user2_answer.body
        expect(page).not_to have_selector(:css, '.best-answer')
        expect(page).to have_selector(:css, '.best-answer-link')

        accept_confirm { click_on t('answers.answer_body.choose_best') }
      end

      within('.answers>.card:first-child') do
        expect(page).to have_content user2_answer.body
        expect(page).to have_selector(:css, '.best-answer')
        expect(page).not_to have_selector(:css, '.best-answer-link')
      end

      within('.answers>.card:last-child') do
        expect(page).to have_content user1_answer.body
        expect(page).not_to have_selector(:css, '.best-answer')
        expect(page).to have_selector(:css, '.best-answer-link')

        accept_confirm { click_on t('answers.answer_body.choose_best') }
      end

      within('.answers>.card:first-child') do
        expect(page).to have_content user1_answer.body
        expect(page).to have_selector(:css, '.best-answer')
        expect(page).not_to have_selector(:css, '.best-answer-link')
      end

      within('.answers>.card:last-child') do
        expect(page).to have_content user2_answer.body
        expect(page).not_to have_selector(:css, '.best-answer')
        expect(page).to have_selector(:css, '.best-answer-link')
      end
    end

    scenario "Picks answer to another's question", js: true do
      sign_in(user2)

      visit question_path(user1_question)
      within('.answers>.card:last-child') do
        expect(page).not_to have_selector(:css, '.best-answer-link')
      end
    end
  end

  scenario 'Guest try to choose answer', js: true do
    visit question_path(user1_question)
    within('.answers>.card:last-child') do
      expect(page).not_to have_selector(:css, '.best-answer-link')
    end
  end
end
