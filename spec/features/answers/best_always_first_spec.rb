# rubocop:disable Metrics/BlockLength

require 'rails_helper'

feature 'The best answer to question is always in first place' do
  given(:user1) { create(:user_with_questions, questions_count: 1) }
  given(:user2) { create(:user) }
  given(:user1_question) { user1.questions.first }

  given!(:answer1) { create(:answer, question: user1_question, user: user2) }
  given!(:answer2) { create(:answer, question: user1_question, user: user2) }

  scenario 'No best questions' do
    visit question_path(user1_question)

    within('.answers>li:first-child') do
      expect(page).to have_content answer1.body
      expect(page).not_to have_content t('answers.answer.best')
    end

    within('.answers>li:last-child') do
      expect(page).to have_content answer2.body
      expect(page).not_to have_content t('answers.answer.best')
    end
  end

  scenario 'Best answer is first in list' do
    answer2.update(best: true)
    answer2.reload

    visit question_path(user1_question)

    within('.answers>li:first-child') do
      expect(page).to have_content answer2.body
      expect(page).to have_content t('answers.answer.best')
    end

    within('.answers>li:last-child') do
      expect(page).to have_content answer1.body
      expect(page).not_to have_content t('answers.answer.best')
    end
  end
end
