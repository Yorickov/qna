require 'rails_helper'

feature 'Autenticated user can delete only his question' do
  given(:user1) { build(:user_with_questions) }
  given(:user2) { build(:user_with_questions) }

  background { sign_in(user1) }

  scenario "Question's author user can delete his question" do
    visit question_path(user1.questions.first)
    click_on t('questions.show.delete_question')

    expect(page).to have_content t('questions.destroy.success')
  end

  scenario "Question's author can't delete another's question" do
    visit question_path(user2.questions.first)

    expect(page).not_to have_content t('questions.show.delete_question')
  end
end
