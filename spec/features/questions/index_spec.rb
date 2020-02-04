require 'rails_helper'

feature 'Guest can see questions' do
  given!(:user) { create(:user_with_questions) }

  scenario 'Guest try to see questions list' do
    visit questions_path

    user.questions.each { |question| expect(page).to have_content(question.title) }
  end
end
