require 'rails_helper'

feature 'Guest can create answer' do
  given(:question) { create(:question) }

  background do
    visit question_path(question)
  end

  scenario 'Create Answer' do
    fill_in t('activerecord.attributes.answer.body'), with: 'answer text'
    click_on t('forms.submit')

    expect(page).to have_content t('answers.create.success')
    expect(page).to have_content 'text'
  end

  scenario 'Create Answer with errors' do
    click_on t('forms.submit')

    expect(page).to have_content t('activerecord.errors.messages.blank')
  end
end
