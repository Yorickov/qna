require 'rails_helper'

feature 'Guest can see questions and answers' do
  given(:user) { build(:user_with_questions) }

  background do
    save_before_sign_in(user)
  end

  scenario 'Guest can see questions list' do
    visit questions_path

    expect(page).to have_content t('questions.index.all_questions')
  end

  scenario 'Guest can see question and answers to him' do
    visit question_path(user.questions.first)

    expect(page).to have_content t('questions.show.answers')
  end
end
