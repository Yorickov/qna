require 'rails_helper'

feature 'Guest can create answer' do
  given(:question) { create(:question) }

  background do
    visit question_path(question)
  end

  scenario 'Create Answer' do
    fill_in 'Body', with: 'answer text'
    click_on 'Create Answer'

    expect(page).to have_content('Answer successfully created')
    expect(page).to have_content('text')
  end

  scenario 'Create Answer with errors' do
    click_on 'Create Answer'

    expect(page).to have_content("Body can't be blank")
  end
end
