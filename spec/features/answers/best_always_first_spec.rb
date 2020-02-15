require 'rails_helper'

feature 'The best answer to question is always in first place' do
  given(:user1) { create(:user_with_questions, questions_count: 1) }
  given(:user2) { create(:user) }
  given(:user1_question) { user1.questions.first }

  given!(:answer1) { create(:answer, question: user1_question, user: user2) }
  given!(:answer2) { create(:answer, question: user1_question, user: user2, best: true) }
  given!(:answer3) { create(:answer, question: user1_question, user: user2) }

  scenario 'Best answer of the question is first and others are sorted by creation time' do
    visit question_path(user1_question)

    within('.answers>.card:nth-child(1)') do
      expect(page).to have_content answer2.body
      expect(page).to have_selector(:css, '.best-answer')
    end

    within('.answers>.card:nth-child(2)') do
      expect(page).to have_content answer1.body
      expect(page).not_to have_selector(:css, '.best-answer')
    end

    within('.answers>.card:nth-child(3)') do
      expect(page).to have_content answer3.body
      expect(page).not_to have_selector(:css, '.best-answer')
    end
  end
end
