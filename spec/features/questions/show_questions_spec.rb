require 'rails_helper'

feature 'Guest can see questions and answers' do
  given!(:user1) { create(:user_with_questions, questions_count: 1) }
  given!(:user2) { create(:user_with_questions, questions_count: 1) }

  scenario 'Guest try to see questions list' do
    visit questions_path

    Question.all.each { |q| expect(page).to have_content(q.title) }
  end

  scenario 'Guest try to see question and answers to him' do
    create(:answer, question: user2.questions.first, user: user1)
    create(:answer, question: user1.questions.first, user: user2)

    visit question_path(user1.questions.first)

    user1.questions.first.answers.each { |a| expect(page).to have_content(a.body) }
  end
end
