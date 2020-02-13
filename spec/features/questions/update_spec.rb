# rubocop:disable Metrics/BlockLength

require 'rails_helper'

feature 'Only author can edit his question' do
  given(:user1) { create(:user_with_questions, questions_count: 1) }
  given(:user2) { create(:user_with_questions, questions_count: 1) }
  given(:user1_question) { user1.questions.first }
  given!(:question_with_files1) { create(:question, :with_files, user: user1) }
  given!(:question_with_files2) { create(:question, :with_files, user: user2) }

  describe 'Authenticated user' do
    background { sign_in(user1) }

    scenario 'edits his question by changing title and body', js: true do
      visit question_path(user1_question)
      click_on t('questions.question_body.edit_question')

      within '.question-node' do
        fill_in t('activerecord.attributes.question.title'), with: 'edited title'
        fill_in t('activerecord.attributes.question.body'), with: 'edited body'
        click_on t('forms.submit_question')

        expect(page).to_not have_content user1_question.title
        expect(page).to_not have_content user1_question.body
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question by attaching files', js: true do
      visit question_path(user1_question)
      click_on t('questions.question_body.edit_question')

      within '.question-node' do
        expect(page).not_to have_link 'test-image1.png'
        expect(page).not_to have_link 'test-image2.png'

        attach_file t('activerecord.attributes.question.files'), [
          "#{Rails.root}/spec/rails_helper.rb",
          "#{Rails.root}/spec/spec_helper.rb"
        ]

        click_on t('forms.submit_question')
        sleep 1

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'delete attaching files', js: true do
      visit question_path(question_with_files1)

      expect(page).to have_link 'test-image1.png'
      expect(page).to have_link 'test-image2.png'

      within('.attachments>p:last-child') do
        click_on t('attachments.attachment.delete_attachment')
        page.driver.browser.switch_to.alert.accept
        sleep 1
      end

      expect(page).to have_link 'test-image1.png'
      expect(page).not_to have_link 'test-image2.png'
    end

    scenario 'edits his question with errors', js: true do
      visit question_path(user1_question)
      click_on t('questions.question_body.edit_question')

      fill_in t('activerecord.attributes.question.title'), with: 'edited title'
      fill_in t('activerecord.attributes.question.body'), with: ''
      click_on t('forms.submit_question')

      expect(page).to have_content t('activerecord.errors.messages.blank')
      expect(page).to have_content user1_question.body
    end

    scenario "edits another's question", js: true do
      visit question_path(question_with_files2)

      expect(page).to have_content question_with_files2.body
      expect(page).not_to have_content t('questions.question_body.edit_question')
      expect(page).not_to have_link t('attachments.attachment.delete_attachment')
    end
  end

  scenario 'Guest try to edit question', js: true do
    visit question_path(question_with_files1)

    expect(page).to have_content question_with_files1.body
    expect(page).not_to have_content t('questions.question_body.edit_question')
    expect(page).not_to have_link t('attachments.attachment.delete_attachment')
  end
end
