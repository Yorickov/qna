require 'rails_helper'

feature 'User can create comment' do
  given(:user) { create(:user_with_questions) }
  given(:question) { user.questions.first }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'makes comment' do
    end

    scenario 'makes comment with errors' do
    end
  end

  describe 'As a Guest', js: true do
    scenario 'tries to make a comment' do
    end
  end
end
