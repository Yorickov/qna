require 'rails_helper'

feature 'Guest can see questions and answers' do
  scenario 'Guest can see questions list' do
    visit questions_path

    expect(page).to have_content('All questions')
  end

  scenario 'Guest can see question and answers to him' do
    visit question_path(create(:question))

    expect(page).to have_content('Answers')
  end
end
