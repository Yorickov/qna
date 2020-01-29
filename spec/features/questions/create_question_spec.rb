require 'rails_helper'

feature 'Guest can create question' do
  background do
    visit questions_path
    click_on 'Ask question'
  end

  scenario 'Asks a question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'question text'
    click_on 'Create Question'

    expect(page).to have_content 'Question successfully created'
    expect(page).to have_content('Test question')
    expect(page).to have_content('question text')
  end

  scenario 'Asks a question with errors' do
    click_on 'Create Question'

    expect(page).to have_content("Title can't be blank")
  end
end
