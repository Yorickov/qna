feature 'Autenticated user can delete only his question' do
  let(:user1) { build(:user_with_questions) }
  let(:user2) { build(:user_with_questions) }

  background do
    save_before_sign_in(user2)

    sign_in(user1)
  end

  scenario 'Autenticated user can delete his question' do
    visit question_path(user1.questions.first)
    click_on t('questions.show.delete')

    expect(page).to have_content t('questions.destroy.success')
  end

  scenario "Autenticated user can't delete another's question" do
    visit question_path(user2.questions.first)

    expect(page).not_to have_content t('questions.show.delete')
  end
end
