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

  scenario 'User adds award while adding question', js: true do
    fill_in t('activerecord.attributes.award.title'), with: 'My award1'
    attach_file t('activerecord.attributes.award.image'),
                "#{Rails.root}/spec/support/assets/test-image1.png"

    click_on t('forms.submit_question')

    within('.question-image') do
      expect(page).to have_css("img[src*='test-image1.png']")
    end
  end

  scenario 'User award while adding question without title', js: true do
    fill_in t('activerecord.attributes.award.title'), with: ''
    attach_file t('activerecord.attributes.award.image'),
                "#{Rails.root}/spec/support/assets/test-image1.png"

    click_on t('forms.submit_question')

    expect(page).to have_content t('activerecord.errors.messages.blank')
  end

  scenario 'User award while adding question without image', js: true do
    fill_in t('activerecord.attributes.award.title'), with: 'Test'

    click_on t('forms.submit_question')

    expect(page).to have_content t('activerecord.errors.messages.no_image')
  end
end
