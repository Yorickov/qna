require 'rails_helper'

feature 'Guest can see questions and answers' do
  given!(:user) { create(:user_with_questions) }

  scenario 'Guest try to see questions list' do
    visit questions_path

    Question.all.each { |q| expect(page).to have_content(q.title) }
  end
end
