require 'rails_helper'

feature 'Autenticated user can delete only his answers' do
  given(:user1) { build(:user_with_questions) }
  given(:user2) { build(:user_with_questions) }

  background do
    sign_in(user1)

    create(:answer, question: user2.questions.first, author: user1)
    create(:answer, question: user1.questions.first, author: user2)
  end

  scenario "Answer's author user can delete his answer" do
    visit question_path(user2.questions.first)

    click_on t('answers.answer.delete_answer')

    expect(page).to have_content t('answers.destroy.success')
  end

  scenario "Answer's author can't delete another's answer" do
    visit question_path(user1.questions.first)

    expect(page).not_to have_content t('answers.answer.delete_answer')
  end
end
