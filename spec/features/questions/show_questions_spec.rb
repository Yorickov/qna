require 'rails_helper'

feature 'Guest can see questions and answers' do
  given(:user1) { build(:user_with_questions) }
  given(:user2) { build(:user_with_questions) }

  background do
    save_before_sign_in(user1)
    save_before_sign_in(user2)
  end

  scenario 'Guest can see questions list' do
    visit questions_path

    Question.all.each { |q| expect(page).to have_content(q.title) }
  end

  scenario 'Guest can see question and answers to him' do
    create(:answer, question: user1.questions.first, author: user1)
    create(:answer, question: user1.questions.first, author: user2)

    visit question_path(user1.questions.first)

    user1.questions.first.answers
         .each { |a| expect(page).to have_content(a.body) }
  end
end
