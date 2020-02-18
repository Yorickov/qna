# rubocop:disable Metrics/BlockLength

require 'rails_helper'

feature 'Author can add award to his question' do
  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path

    fill_in t('activerecord.attributes.question.title'), with: 'Test question'
    fill_in t('activerecord.attributes.question.body'),  with: 'question text'

    click_on t('forms.add_award')
  end

  scenario 'Author adds award while adding question' do
    within('.links>.nested-fields') do
      fill_in t('activerecord.attributes.award.title'), with: 'My award1'
      attach_file t('activerecord.attributes.award.image'), [
        "#{Rails.root}/spec/support/assets/test-image1.png"
      ]
    end

    click_on t('forms.submit_question')

    expect(page).to have_content 'My award1'
    expect(page).to have_selector(:css, 'img')
  end
end
