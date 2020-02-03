require 'rails_helper'

feature 'Guest can see questions and answers' do
  given(:user) { create(:user_with_questions, questions_count: 1) }
  given(:question) { user.questions.first }
  given!(:answers) { create_list(:answer, 2, question: question, user: user) }

  background { visit question_path(question) }

  scenario 'Guest try to see question' do
    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
  end

  scenario 'Guest try to see answers to the question' do
    answers.each { |answer| expect(page).to have_content(answer.body) }
  end
end
