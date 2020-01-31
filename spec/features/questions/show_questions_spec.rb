require 'rails_helper'

feature 'Guest can see questions and answers' do
  given!(:user1) { build(:user_with_questions) }
  given!(:user2) { build(:user_with_questions) }

  scenario 'Guest can see questions list' do
    visit questions_path

    expect(Question.count).to eq(4)
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
