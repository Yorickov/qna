require 'rails_helper'

feature 'Guest can see questions and answers' do
  given!(:user1) { create(:user_with_questions, questions_count: 1) }
  given!(:user2) { create(:user_with_questions, questions_count: 1) }

  given!(:answer1) { create(:answer, question: user2.questions.first, user: user1) }
  given!(:answer2) { create(:answer, question: user1.questions.first, user: user2) }

  scenario 'Guest try to see question and answers to him' do
    question = user1.questions.first

    visit question_path(question)

    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)

    question.answers.each { |a| expect(page).to have_content(a.body) }
  end
end
